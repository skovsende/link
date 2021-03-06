:Namespace FileSystemWatcher

    (⎕IO ⎕ML)←1 1

    ∇ WatchEvent(obj args);nargs
     ⍝ Callback for System.IO.FileSystemWatcher instance
  ⍝     Passes info on to ⎕SE.Link.Notify for processing
     
      {}2501⌶0 ⍝ kill thread on exit
     
      nargs←⊂819⌶⍕args.ChangeType             ⍝ type: created|changed|deleted|renamed
      nargs,←⊂args.FullPath
      :If 0≠⎕NC⊂'args.OldFullPath'
          nargs,←⊂args.OldFullPath
      :EndIf
     
      {}⎕SE.Link.Notify nargs
    ∇
	
    ∇ r←Watch args;⎕USING;path;filter;watcher
     ⍝ args: path filter
     
      ⎕USING←',System.dll'
      watcher←⎕NEW System.IO.FileSystemWatcher
      watcher.(Path Filter)←args
      watcher.(onChanged onCreated onDeleted onRenamed)←⊂'WatchEvent'
      watcher.IncludeSubdirectories←1
      watcher.EnableRaisingEvents←1
     
      r←⎕NEW Disposable watcher ⍝ wrap a destructor around it
    ∇

    :Class Disposable

        :Field Public Object

        ∇ make ref
          :Access Public
          :Implements Constructor
          Object←ref
        ∇

        ∇ do_dispose ref
          :Trap 0
              ref.Dispose
          :EndTrap
        ∇

        ∇ dispose;tid
          :Implements Destructor 
          Object.EnableRaisingEvents←0
          tid←do_dispose&Object
        ∇

    :EndClass

:EndNamespace
