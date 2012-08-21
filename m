Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2HUHMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:12:53 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:56137 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2HUHMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:12:51 -0400
Message-ID: <503334E9.508@free-electrons.com>
Date: Tue, 21 Aug 2012 09:12:41 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, linux-doc@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/11] pinctrl: mvebu: add pinctrl driver for Armada 370
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com> <1344689809-6223-5-git-send-email-sebastian.hesselbarth@gmail.com> <CACRpkdYNZar7865-T12J37h3AWA9-8R1R5tymuOhaB0b3ddEAA@mail.gmail.com> <50326A60.1070007@gmail.com> <20120820193622.4e539451@skate>
In-Reply-To: <20120820193622.4e539451@skate>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 07:36 PM, Thomas Petazzoni wrote:
> Le Mon, 20 Aug 2012 18:48:32 +0200,
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> a écrit :
> 
>> this is really difficult here ;) I thought I could just add PINCTRL_DOVE
>> to MACH_DOVE inside ARCH_MVEBU, PINCTRL_KIRKWOOD to MACH_KIRKWOOD, aso.
>> But there is a common MACH_ARMADA_370_XP for both 370 and XP obviously.
>>
>> If it is ok for you I will add both PINCTRL_ stubs to the Kconfig and
>> you work it out if you ever have two distinct MACHs? Or it could remain
>> selectable in pinctrl/Kconfig but that will then be different with the
>> other stubs.
> 
> In order to keep the consistency with other SoC families, maybe we can
> split the 370 and XP options in two separate MACH_ARMADA_370 and
> MACH_ARMADA_XP. So, in the ideal world, once all Marvell EBU SoCs are
> converted to DT+mach-mvebu, we should have:
> 
>  *) arch/arm/Kconfig defines MACH_MVEBU
> 
>  *) arch/arm/mach-mvebu/Kconfig defines MACH_KIRKWOOD, MACH_DOVE,
>     MACH_MX78X00, MACH_ARMADA_370, MACH_ARMADA_XP, MACH_ORION5X
> 
> Then, an user is free to build a single kernel image that supports all,
> or a selection of the supported Marvell EBU SoCs.

I agree with Thomas

> 
> Thomas
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
