Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3ACVQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 16:16:50 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34358 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3ACVQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 16:16:47 -0500
Message-ID: <50E5F539.8060600@wwwdotorg.org>
Date: Thu, 03 Jan 2013 14:16:41 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, John Stultz <johnstul@us.ibm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Olof Johansson <olof@lixom.net>, Rob Landley <rob@landley.net>,
        linux-tegra@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/9] ARM: Initial support for Tegra 114 SoC.
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com> <20130103210036.GA4412@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130103210036.GA4412@avionic-0098.adnet.avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 02:00 PM, Thierry Reding wrote:
> On Thu, Dec 20, 2012 at 11:43:58AM +0200, Hiroshi Doyu wrote:
>> Hi,
>> 
>> This patchset adds initial support for the NVIDIA's new Tegra
>> 114 SoC (T114) based on the ARM Cortex-A15 MP. It has the minimal
>> support to allow the kernel to boot up into shell console. This
>> can be used as a basis for adding other device drivers for this
>> SoC. Currently there are 2 evaluation boards available, "Dalmore"
>> and "Pluto".
>> 
>> This patchset is against Stephen Warren's linux-next_common
>> branch:
>> 
>> git://nv-tegra.nvidia.com/user/swarren/linux-2.6
>> linux-next_common
>> 
>> For those who want to try:
>> 
>> $ make ARCH=arm tegra_defconfig $ scripts/config -e
>> ARCH_TEGRA_114_SOC -d DRM -d SUSPEND \ -d PM_RUNTIME -d CPU_FREQ
>> -d CPU_IDLE
> 
> I wonder, what's the reason for disabling DRM? And while on the
> topic, are there any plans to release a Tegra114 TRM?

AFAIK, the HW is basically compatible with previous chips, so I expect
to see a DRM driver for it show up once all the various more basic
devices are supported.
