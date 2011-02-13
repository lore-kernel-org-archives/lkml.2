Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1BMCbK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 21:31:10 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:36845 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab1BMCbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 21:31:06 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
References: <026101cbca54$b95489e0$2bfd9da0$@mprc.pku.edu.cn> <AANLkTim99mRGrMa+n+2AiOXPuf6-xM-dcELUGX0ssMpP@mail.gmail.com> <201102122011.34664.arnd@arndb.de>
In-Reply-To: <201102122011.34664.arnd@arndb.de>
Subject: RE: [GIT PULL] UniCore32 ISA support for linux-2.6
Date: Sun, 13 Feb 2011 10:30:54 +0800
Message-ID: <02d701cbcb26$0a4aa150$1edfe3f0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGgLvOjZ+Vm94LPUyLIF2scFfK7yAGFHWyCAoVe+uWUNY9DAA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Sunday, February 13, 2011 3:12 AM
> To: Linus Torvalds
> Cc: Guan Xuetao; linux-kernel@vger.kernel.org
> Subject: Re: [GIT PULL] UniCore32 ISA support for linux-2.6
> 
> On Saturday 12 February 2011 18:51:32 Linus Torvalds wrote:
> > On Fri, Feb 11, 2011 at 5:32 PM, Guan Xuetao <gxt@mprc.pku.edu.cn> wrote:
> > > Hi Linus,
> > >  Could you please pull from:
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git for_linus
> > >  to add unicore32 support for linux-2.6.
> >
> > I'm not going to do it during the 38 cycle, but if this has has gotten
> > ack's from people like Arnd, and all the commentary from other people
> > (like the "the ptrace.c file looks like it was copied from arm, wants
> > attribution" etc), I can pull it in the 39 cycle.
> 
> I think it should still be posted once more to linux-arch/linux-kernel
> as emails. I gave an Acked-by to a number of patches that are
> harmless and that I didn't have any comments on.
Yes, I will.
I remain your Acked-by for ptrace patch, and please acknowledge it again.

> 
> There are a number of patches that I reviewed more thoroughly, and
> Guan did a good job of cleaning up the code based on that. I believe
> it's basically good to go into 2.6.39 once they go over the mailing
> list in the current version. I'll reply with a Reviewed-by tag to the
> patches that I reviewed and that now look ok when that happens.
> 
> There are a few remaining issues from the review, which can probably
> be addressed in a later version. For instance, I suggested the use
> of a flattened device tree for enumerating the nondiscoverable
> SoC devices, which should help long-term maintainance, but is not
> essential.
> 
> I should probably have been clearer about the timing for merging.
> While I must have mentioned it at some point, there were a lot of
> things I needed to explain about the process, so it probably
> got lost.
Yes.
It's my wrong to advance the process rashly.

> 
> > Arnd - who else was involved in the reviews? Is there somebody who
> > should have been involved and wasn't?
> 
> A few people commented on specific patches, but I don't think anyone
> besides me looked at all of it. Greg and others reviewed the
> device drivers, so I did not bother with those.
I hope to involve some necessary drivers for first merging.
So, I post i8042,  i2c, framebuffer,  and mac drivers to related maintainers and maillists.
And acknowledged drivers were added to my git repo.

> 
> I don't know enough about the signal handling code to do a good review,
> and I tried to get Al Viro involved at some point, but didn't get his
> attention.
With new abi, I rearranged the signal handler, simpler and neater for review.

> 
> 	Arnd

Thanks & Regards.

Guan Xuetao

