Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0LJI4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 03:56:35 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:55280 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab0LJI4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 03:56:34 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Thomas Gleixner'" <tglx@linutronix.de>, "'Tejun Heo'" <tj@kernel.org>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <01ca01cb9783$7818c3f0$684a4bd0$@mprc.pku.edu.cn> <4D00A672.9050906@kernel.org> <alpine.LFD.2.00.1012091443580.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012091443580.2653@localhost6.localdomain6>
Subject: RE: [PATCHv1 000/211] unicore32 architecture support
Date: Fri, 10 Dec 2010 16:56:08 +0800
Message-ID: <026901cb9848$17e71ac0$47b55040$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIaQMzs4RUpMf2KgIH0ug+QPeuZKAJpolxXAoNVYeKS1KaWAA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-arch-owner@vger.kernel.org [mailto:linux-arch-
> owner@vger.kernel.org] On Behalf Of Thomas Gleixner
> Sent: Thursday, December 09, 2010 9:50 PM
> To: Tejun Heo
> Cc: Guan Xuetao; Arnd Bergmann; linux-arch@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCHv1 000/211] unicore32 architecture support
> 
> B1;2401;0cOn Thu, 9 Dec 2010, Tejun Heo wrote:
> 
> > Hello,
> >
> > On 12/09/2010 10:28 AM, Guan Xuetao wrote:
> > > From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> > >
> > > These patches add support for UniCore-32 ISA in linux kernel.
> > > UniCore ISA is defined and developed by Micro-Processor R&D Center
> > > of Peking University, and over the years, the CPUs and SoCs using
> > > UniCore ISA have been successfully applied in a variety of products in
> China.
> >
> > * Patches should be split according to logical steps of changes, not
> >   per-file.
> >
> > * Patches should be bisectable.  IOW, after applying upto any patch in
> >   the series, the tree should be buildable and working.
> 
> That does not work for a new architecture. There is nothing to bisect.
> 
> > * When posting a patch series, especially one as large as 211, please
> >   make the mails for the actual patches replies to the head message.
> >   Don't post it as 212 separate messages or replies to the immediate
> >   previous patch.
> >
> > So, in short, if you're adding a whole new arch, just post it as a
> > single patch or a series of several patches if it requires changes
> > outside of the specific arch subtree.
> 
> Crap. a single patch is a major PITA for review. It's even worse than
> 211 per file patches.
> 
> It's ok to have several patches ordered by topics
> 
>   - generic header stuff
>   - processor and system headers
>   - low level entry and setup code
>   - process/thread related code
>   - mm related code
>   - timers
>   - interrupts
>   - ptrace
>   - signals
>   - fault handling
>   - misc
>   - build system, main makefile, Kconfig
> 
> That makes it actually feasible to review.
Thanks,
I will rearrange my patches.

Guan Xuetao

