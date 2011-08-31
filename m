Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab1HaEZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 00:25:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54709 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab1HaEZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 00:25:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="113988649"
Date: Tue, 30 Aug 2011 21:25:32 -0700
From: David Brown <davidb@codeaurora.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] msm: devboard defconfigs
Message-ID: <20110831042532.GA14892@huya.qualcomm.com>
References: <20110830225213.GB7093@huya.qualcomm.com>
 <alpine.LFD.2.00.1108302021530.20358@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1108302021530.20358@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 08:23:21PM -0400, Nicolas Pitre wrote:
> On Tue, 30 Aug 2011, David Brown wrote:
> 
> > Unless Russell objects, and prefers these to be in his tree, I'm fine
> > with having these in a branch for linux-next that isn't merged
> > upstream for now.
> > 
> > The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:
> > 
> >   Linux 3.1-rc4 (2011-08-28 21:16:01 -0700)
> > 
> > are available in the git repository at:
> >   git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-defconfig
> > 
> > David Brown (1):
> >       ARM: msm: defconfigs for Qualcomm dev boards
> > 
> >  arch/arm/configs/msm7x30_defconfig |   68 +++++++++
> >  arch/arm/configs/msm8660_defconfig |   96 +++++++++++++
> >  arch/arm/configs/msm8960_defconfig |  265 ++++++++++++++++++++++++++++++++++++
> >  arch/arm/configs/qsd8x50_defconfig |   82 +++++++++++
> 
> What prevents you from merging them together?
> Can't you build a single kernel binary with support for allMSM targets?

Not yet, still a good bunch of things that need to happen before that
can be done.  I'm not even sure it's going to be possible before
device tree, since the memory block where I read to determine which
CPU I'm on differs from platform to platform.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
