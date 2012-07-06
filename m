Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab2GFXYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 19:24:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417Ab2GFXYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 19:24:32 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CAERv70uZMEoX4OcECssOrktVzC911tiSLXRH56TjyhQqVgNwBA@mail.gmail.com>
References: <1341571127-14461-1-git-send-email-jgq516@gmail.com>
	<4FF6DCCA.2080509@gmail.com>
	<CAERv70uZMEoX4OcECssOrktVzC911tiSLXRH56TjyhQqVgNwBA@mail.gmail.com>
Date: Fri, 6 Jul 2012 16:24:32 -0700
Message-ID: <CAOesGMjmeXVx2MR7GGux9Cztkf-C3cBqpBW1_PW75D_Gk0GHiA@mail.gmail.com>
Subject: Re: [PATCH 1/1] ARM: add PROC_DEVICETREE support in Kconfig
From: Olof Johansson <olof@lixom.net>
To: Xiao Jiang <jgq516@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>, linux@arm.linux.org.uk,
        tony@atomide.com, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com,
        arnd@arndb.de, swarren@nvidia.com, ldewangan@nvidia.com,
        hdoyu@nvidia.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 4:15 PM, Xiao Jiang <jgq516@gmail.com> wrote:
> 2012/7/6 Rob Herring <robherring2@gmail.com>
>>
>> On 07/06/2012 05:38 AM, jgq516@gmail.com wrote:
>> > From: Xiao Jiang <jgq516@gmail.com>
>> >
>> > Since more and more arm chips support device tree, it'd be better add
>> > PROC_DEVICETREE
>> > in arch/arm/Kconfig to avoid duplicate code.
>>
>> I think this should remain user choice. If its going to be selected,
>> then you might as well just remove the option altogether. Perhaps just
>> make the option default to yes.
>>
> Hmm, sounds reasonable from your point. So the better choice is to set the
> option default to Y if the board has dt support just like tegra_defconfig
> and at91_dt_defconfig,  right? thanks.

Why bother? If the defconfigs select it then most users basing their
config from that will be just fine.

PROC_DEVICETREE is 100% optional, it's useful to get runtime access to
the contents of the device tree but it's not required for the kernel
to boot.


-Olof
