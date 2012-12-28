Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2L1Wic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 17:38:32 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:42415 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2L1Wib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 17:38:31 -0500
Date: Fri, 28 Dec 2012 23:38:28 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        anish singh <anish198519851985@gmail.com>,
        amit mehta <gmate.amit@gmail.com>,
        Henrique Rodrigues <henriquesilvar@gmail.com>,
        kishore kumar <kishoreopen@gmail.com>,
        =?ISO-8859-15?Q?Jonathan_Neusch=E4fer?= <j.neuschaefer@gmx.net>,
        linux-kernel@vger.kernel.org, Kernelnewbies@kernelnewbies.org
Subject: Re: how to look for source code in kernel
In-Reply-To: <Pine.LNX.4.64.1212282321370.2539@axis700.grange>
Message-ID: <alpine.LNX.2.00.1212282336360.32254@swampdragon.chaosbits.net>
References: <CA+8YGd6UqfbzEHOb2NUL5p3EF4OECVq7yc2vRV3GViVT64CTbQ@mail.gmail.com> <20121227184034.GA2982@debian.debian> <CABuSbKbk5DdhvuwYUeLkm=eub1CsSaOB_oX7bkBZcAV_MNsSdg@mail.gmail.com> <CAK7N6vpvLrAb=sZitaEBQ6Fx4K5ehGg+LTU70hiVK=1RdE4WwQ@mail.gmail.com>
 <CAOUxTKNgs4N-M5RR6YHyGeXQqRrg0_CJpxgT2OmN_buEP+jbjQ@mail.gmail.com> <CAK7N6vqw+DVSVaCXqiQBVa_d2o-rg-oA5t8+6WNaZ9Mb_iQqdw@mail.gmail.com> <87a9syhbma.fsf@xmission.com> <20121228130734.GB13224@x1.alien8.de> <Pine.LNX.4.64.1212282321370.2539@axis700.grange>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2012, Guennadi Liakhovetski wrote:

> On Fri, 28 Dec 2012, Borislav Petkov wrote:
> 
> > On Thu, Dec 27, 2012 at 11:36:13PM -0800, Eric W. Biederman wrote:
> > > git-ls-files | xargs fgrep 'struct f2fs_inode'
> > > 
> > > That returns instantly and tells me where to look.  If you can do an
> > > instant brute force search what is the point of an index?
> > 
> > Not if you're using a lame-ass laptop with a rotating disk:
> > 
> > $ time git ls-files | xargs grep -E 'struct mce\W*{'
> > arch/x86/include/uapi/asm/mce.h:struct mce {
> > arch/x86/kernel/cpu/mcheck/mce.c:               if (!final || memcmp(m, final, sizeof(struct mce))) {
> > 
> > real    2m48.415s
> > user    0m2.388s
> > sys     0m15.668s
> > 
> > What I've grown accustomed to is cscope with a prior find run on the
> > kernel source tree to create a custom cscope.files which cscope uses to
> > index and then using vim bindings in cscope so that if, for example, the
> > cursor is on a function call, executing a keyboard shortcut opens the
> > definition of that function in another vim tab. I.e., a thin IDE done
> > right.
> 
> ...same works with TAGS under emacs, the only annoying problem with it 
> since "recently" (about half a year or more) is that "make TAGS" is 
> spewing out tons of
> 
> etags: Unmatched ( or \( while compiling pattern
> 
> oh well, looks like noone is using it / noone cares enough...
> 
I use it. I haven't bothered (yet) to look into the cause of the message 
it spews since the etags ('TAGS') file it produces still seems to work 
well enough.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

