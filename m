Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab0FHQhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 12:37:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62387 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab0FHQhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 12:37:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6007"; a="43782266"
Subject: Re: ARM defconfig files
From: Daniel Walker <dwalker@codeaurora.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <tnxeighczk7.fsf@e102109-lin.cambridge.arm.com>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	 <1275584003.23384.2.camel@c-dwalke-linux.qualcomm.com>
	 <tnxeighczk7.fsf@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 09:37:37 -0700
Message-ID: <1276015057.14529.7.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 16:30 +0100, Catalin Marinas wrote:
> Daniel Walker <dwalker@codeaurora.org> wrote:
> > Have you noticed this ..
> >
> > http://ktrap.org/mailarchive/linux-kernel/2010/5/17/4571130
> >
> > I'm not sure of the goals, but it sounds like it might be relevant.
> 
> In some cases you don't want to automatically enable features but rather
> fix the Kconfig file. For example, with the select dependencies patch
> (http://lkml.org/lkml/2009/9/16/413) on ARMv7 RealView I get the
> following:
> 
> warning: (CPU_V7 && !ARCH_OMAP2 || CPU_MMP2 && ARCH_MMP) selects
> CPU_32v6K which has unmet direct dependencies (CPU_V6)
> 
> Unless I misunderstand this, a solver may try to select CPU_V6 which I
> don't want to. The solution is to fix Kconfig as below:

It seems like those are something the solver would likely find, or have
problems with. Since we technically don't have a solver yet it's hard to
say what the end result would be. None the less it's sucks we have
things getting selected without their depends be met or correct..

Daniel

