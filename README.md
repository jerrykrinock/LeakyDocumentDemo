# LeakyDocumentDemo

Video is here:
https://youtu.be/zSQ1hY7JVZs (03:49)

Apple Bug Report 33502122

It looks to me that, in the edge case where user clicks File : Duplicate and then enters a file path/name that already exists in the filesystem, so that Cocoa prompts to "Replace" or "Cancel", the new NSDocument object gets four (4) unbalanced retains, and therefore leaks.  This is reproducible in macOS 10.12 or 10.13, Swift or Objective-C, ARC or not.

I say this because a document which has had this happen does not dealloc as documents normally do when closed (or a few seconds thereafter), but it does dealloc if I send it four unbalanced -release messages, and it I send it five unbalanced -release messages, it crashes as expected.
