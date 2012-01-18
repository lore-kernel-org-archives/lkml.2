Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab2ARAiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:38:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44258 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab2ARAip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:38:45 -0500
Date: Wed, 18 Jan 2012 00:38:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] aush^H^Hdit queue
Message-ID: <20120118003840.GT23916@ZenIV.linux.org.uk>
References: <20120117213429.GS23916@ZenIV.linux.org.uk>
 <CA+55aFw_9Wm=qUH+39wb7Xq5KFTZZ4TqgkwMksrD_Q8G-uO3jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw_9Wm=qUH+39wb7Xq5KFTZZ4TqgkwMksrD_Q8G-uO3jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 04:21:11PM -0800, Linus Torvalds wrote:
> On Tue, Jan 17, 2012 at 1:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > ? ? ? ?By all rights it's Eric's stuff; I hadn't got around to resurrecting
> > audit.git until the end of December and this is what was in his tree (minus
> > a couple of things obsoleted by Miklos' "fsnotify: don't BUG in
> > fsnotify_destroy_mark()"). ?Please, pull from
> > git://git.kernel.org:/pub/scm/linux/kernel/git/viro/audit.git for-linus
> 
> Ugh.
> 
> You have an extra colon there in that git tree address. Please fix your script.

*blink*  Ah, I see...  That's not a script, actually - that's cut'n'paste
from .git/config, where it's in the form "gitolite@ra.kernel.org:/pub/scm/..."
Normally cut'n'paste starts at slash, this time I got lazy and blindly hit
it from ".kernel"...

Anyway, that should've been a part of script.  Fixed...

> But even more annoyingly, this is from the "help text" for one of the
> new options:
 
>   The config option toggles if a task setting it's loginuid requires

*cringe*

Missed that one (and normally I do hunt for typos in commit messaged when
applying).  What do you prefer - fix on top of the branch or --amend to
commit in question + cherry-pick of the rest on top of amended?  Alternatively,
that could be --amend'ed in the merge commit...
