Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab2EGPrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:47:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50412 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2EGPrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:47:21 -0400
Message-ID: <4FA7EE85.7030503@wwwdotorg.org>
Date: Mon, 07 May 2012 09:47:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 1/3] ARM: tegra: Add Tegra AHB driver
References: <201205070859.29174.arnd@arndb.de><20120507.122333.2024326166703361049.hdoyu@nvidia.com><201205071024.48958.arnd@arndb.de> <20120507.143647.508182574757518311.hdoyu@nvidia.com>
In-Reply-To: <20120507.143647.508182574757518311.hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 05:36 AM, Hiroshi Doyu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> Subject: Re: [PATCHv5 1/3] ARM: tegra: Add Tegra AHB driver
> Date: Mon, 7 May 2012 12:24:48 +0200
> Message-ID: <201205071024.48958.arnd@arndb.de>
> 
>> On Monday 07 May 2012, Hiroshi Doyu wrote:
>>> Tegra doesn't enable ARM_AMBA and Tegra doesn't use the following
>>> "drivers/amba/bus.c" right now. I needed to make this directory
>>> available to ones without ARM_AMBA enabled.
>>
>> Ah, right. I looked at arch/arm/Kconfig earlier to see if
>> tegra enabled ARM_AMBA but was accidentally looking
>> at ARCH_INtegraTOR when grepping for TEGRA ;-)
>>
>> Your proposed solution sounds good then.
> 
> Thank you for reviewing patches & ACK. Attached the update one here,
> instead of sending a while series again.

Russell, assuming you're OK with this update patch, is it OK if I take
the whole series through the Tegra tree?
