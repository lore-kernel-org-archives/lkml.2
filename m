Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1BMBwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 20:52:15 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:46210 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab1BMBwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 20:52:08 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "'Arnd Bergmann'" <arnd@arndb.de>
References: <026101cbca54$b95489e0$2bfd9da0$@mprc.pku.edu.cn> <AANLkTim99mRGrMa+n+2AiOXPuf6-xM-dcELUGX0ssMpP@mail.gmail.com>
In-Reply-To: <AANLkTim99mRGrMa+n+2AiOXPuf6-xM-dcELUGX0ssMpP@mail.gmail.com>
Subject: RE: [GIT PULL] UniCore32 ISA support for linux-2.6
Date: Sun, 13 Feb 2011 09:51:22 +0800
Message-ID: <02c301cbcb20$853bec80$8fb3c580$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGgLvOjZ+Vm94LPUyLIF2scFfK7yAGFHWyClEm240A=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Linus Torvalds [mailto:torvalds@linux-foundation.org]
> Sent: Sunday, February 13, 2011 1:52 AM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; Arnd Bergmann
> Subject: Re: [GIT PULL] UniCore32 ISA support for linux-2.6
> 
> On Fri, Feb 11, 2011 at 5:32 PM, Guan Xuetao <gxt@mprc.pku.edu.cn> wrote:
> > Hi Linus,
> >  Could you please pull from:
> >    git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git for_linus
> >  to add unicore32 support for linux-2.6.
> 
> I'm not going to do it during the 38 cycle, but if this has has gotten
> ack's from people like Arnd, and all the commentary from other people
> (like the "the ptrace.c file looks like it was copied from arm, wants
> attribution" etc), I can pull it in the 39 cycle.
I will repost the patches, and hope them to be fetched in the 39 cycle.
And ptrace.c file has been modified, sorry and thanks to Russell King.
 
> 
> Arnd - who else was involved in the reviews? Is there somebody who
> _should_ have been involved and wasn't?
Arnd gave me great help.
Many people helped me refine the codes.
Thanks everybody.

> 
>                         Linus

Thanks & Regards.

Guan Xuetao

