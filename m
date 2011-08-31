Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1HaAX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 20:23:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61215 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab1HaAX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 20:23:26 -0400
Date: Tue, 30 Aug 2011 20:23:21 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: David Brown <davidb@codeaurora.org>
cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] msm: devboard defconfigs
In-Reply-To: <20110830225213.GB7093@huya.qualcomm.com>
Message-ID: <alpine.LFD.2.00.1108302021530.20358@xanadu.home>
References: <20110830225213.GB7093@huya.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011, David Brown wrote:

> Unless Russell objects, and prefers these to be in his tree, I'm fine
> with having these in a branch for linux-next that isn't merged
> upstream for now.
> 
> The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:
> 
>   Linux 3.1-rc4 (2011-08-28 21:16:01 -0700)
> 
> are available in the git repository at:
>   git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-defconfig
> 
> David Brown (1):
>       ARM: msm: defconfigs for Qualcomm dev boards
> 
>  arch/arm/configs/msm7x30_defconfig |   68 +++++++++
>  arch/arm/configs/msm8660_defconfig |   96 +++++++++++++
>  arch/arm/configs/msm8960_defconfig |  265 ++++++++++++++++++++++++++++++++++++
>  arch/arm/configs/qsd8x50_defconfig |   82 +++++++++++

What prevents you from merging them together?
Can't you build a single kernel binary with support for allMSM targets?


Nicolas
