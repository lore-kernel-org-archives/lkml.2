Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab1HVCiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 22:38:55 -0400
Received: from ozlabs.org ([203.10.76.45]:45333 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab1HVCix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 22:38:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PULL] lguest fix, virtio documentation
In-Reply-To: <1313419712.3004.1.camel@sasha>
References: <87sjp37au3.fsf@rustcorp.com.au> <1313419712.3004.1.camel@sasha>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 22 Aug 2011 09:42:47 +0930
Message-ID: <87k4a65mo0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011 17:48:32 +0300, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Mon, 2011-08-15 at 10:25 +0930, Rusty Russell wrote:
> > [ This adds a text copy of the virtio draft spec to the kernel source,
> >   which should make it easier for people to find and read.  The master
> >   is still the lyx document on my server, so I'll keep it in sync. ]
> > 
> > The following changes since commit 91d85ea6786107aa2837bef3e957165ad7c8b823:
> > 
> >   Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging (2011-08-13 18:37:28 -0700)
> > 
> > are available in the git repository at:
> > 
> >   ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master
> > 
> > Rusty Russell (2):
> >       virtio: Add text copy of spec to Documentation/virtual.
> 
> The "Device Status" paragraph says FAILED is 8, while it should be 0x80.

They're 1-based bit numbers.  But since everyone makes this mistake,
I've changed them *all* to values rather than bit numbers.

Thanks!
Rusty.
