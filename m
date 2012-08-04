Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab2HDITP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 04:19:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50349 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab2HDITL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 04:19:11 -0400
Date: Sat, 4 Aug 2012 09:19:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dongsheng Song <dongsheng.song@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: Linux 3.6-rc1
Message-ID: <20120804081907.GK23464@ZenIV.linux.org.uk>
References: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
 <1343976472.1730.18.camel@sauron.fi.intel.com>
 <CA+55aFz322dKXUwtmrrW=nfp5XJa5ACh1syE8RXOOdcA7V_76A@mail.gmail.com>
 <20120804044659.GI23464@ZenIV.linux.org.uk>
 <1344058715.1716.1.camel@kyv>
 <20120804061904.GJ23464@ZenIV.linux.org.uk>
 <CAE8XmWphq=XG3aSHWuwcnkKCnyeZ7dGzd0fjpJCKx90bvEKBQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE8XmWphq=XG3aSHWuwcnkKCnyeZ7dGzd0fjpJCKx90bvEKBQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 03:51:01PM +0800, Dongsheng Song wrote:
> On Sat, Aug 4, 2012 at 2:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> >  Documentation/sysctl/vm.txt.rej        |   21 +++++++++++++
> 
> vm.txt.rej ???

Grrr...  git add Documentation/sysctl/ during conflict-resolving in git am, having
forgotten that this turd wasn't removed in process, then a bit of blindness when
generating and pasting the diffstat ;-/  Thanks for spotting.

I've put the branch sans that idiocy in the same tree; for-linus-2 (basically,
branched off at the commit introducing that, then git rm Documentation/sysctl/*.rej
to get rid of that sucker, git commit --amend, git cherry-pick <branchpoint>..for-linus)

Same shortlog, same diffstat sans that idiocy...  Alternatively, it could be fixed
up upon merge, if Linus is really dead set against any rebases (same git rm/git commit --amend
right after git merge or git pull, whatever Linus uses).

Sorry about that ;-/
