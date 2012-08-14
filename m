Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2HNAXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 20:23:43 -0400
Received: from ozlabs.org ([203.10.76.45]:37080 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab2HNAXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 20:23:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        "David Howells" <dhowells@redhat.com>
Subject: Re: linux-next: Tree for July 26 (uml)
In-Reply-To: <502932A0.3060001@xenotime.net>
References: <20120726150419.0de645e8750e3a15fa0f1aaa@canb.auug.org.au> <50115FCF.4060708@xenotime.net> <502932A0.3060001@xenotime.net>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 14 Aug 2012 09:43:38 +0930
Message-ID: <87a9xys53h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2012 10:00:16 -0700, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 07/26/2012 08:18 AM, Randy Dunlap wrote:
> 
> > On 07/25/2012 10:04 PM, Stephen Rothwell wrote:
> > 
> >> Hi all,
> >>
> >> Please do not add anything to linux-next included branches/series that is
> >> destined for v3.7 until after v3.6-rc1 is released.
> >>
> >> Reminder: do not rebase your branches before asking Linus to pull them ...
> >>
> >> Changes since 20120725:
> >>
> > 
> > 
> > 
> > uml on x86_64 (defconfig) build fails with:
> > 
> >   CC      arch/x86/um/../kernel/module.o
> > arch/x86/um/../kernel/module.c:96:5: error: redefinition of 'apply_relocate_add'
> > include/linux/moduleloader.h:64:19: note: previous definition of 'apply_relocate_add' was here
> > make[2]: *** [arch/x86/um/../kernel/module.o] Error 1
> > 
> > 
> > 
> 
> 
> 
> Adding Rusty.
> 
> 
> This build error is still happening for uml on x86_64
> in linux-next 20120813.

No huge surprise, I'll punt this to David Howells :)

Cheers,
Rusty.
