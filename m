Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1IMOm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:42:58 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:49886 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754588Ab1IMOm5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:42:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAP05o4KGqbX6KzZjjpXEfyNk5RzYkgKRkn+P9GYvxLA9pgLOxg@mail.gmail.com>
References: <1314255697-15411-1-git-send-email-keshava_mgowda@ti.com>
	<CAP05o4KGqbX6KzZjjpXEfyNk5RzYkgKRkn+P9GYvxLA9pgLOxg@mail.gmail.com>
Date: Tue, 13 Sep 2011 20:12:53 +0530
Message-ID: <CAP05o4+0-=c-HAn=32kvNNFDiy4L=qhmbBdLF3OiQJrh2vuOYw@mail.gmail.com>
Subject: Re: [PATCH 0/5 v8] mfd: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: b-cousson@ti.com
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 10:02 PM, Munegowda, Keshava
<keshava_mgowda@ti.com> wrote:
> On Thu, Aug 25, 2011 at 12:31 PM, Keshava Munegowda
> <keshava_mgowda@ti.com> wrote:
>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>
>> The Hwmod structures and Runtime PM features are implemented
>> For EHCI and OHCI drivers of OMAP3 and OMAP4.
>> The global suspend/resume of EHCI and OHCI
>> is validated on OMAP3430 sdp board with these patches.
>>
>> these patches are rebased to kevin's pm branch and
>> usbhs latest mainline kernel patches
>>
>> TODO:
>>   - Adding pad configurations to Hwmods
>>   - Aggressive clock cutting in usb bus suspends
>>   - Remote Wakeup implementation using irq-chaining
>>
>>
>> Benoit Cousson (1):
>>  arm: omap: usb: ehci and ohci hwmod structures for omap4
>>
>> Keshava Munegowda (4):
>>  arm: omap: usb: ehci and ohci hwmod structures for omap3
>>  arm: omap: usb: register hwmods of usbhs
>>  arm: omap: usb: device name change for the clk names of usbhs
>>  mfd: omap: usb: Runtime PM support
>>
>>  arch/arm/mach-omap2/clock3xxx_data.c       |   26 +-
>>  arch/arm/mach-omap2/clock44xx_data.c       |   10 +-
>>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  281 +++++++++++
>>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  247 ++++++++++
>>  arch/arm/mach-omap2/usb-host.c             |  114 ++---
>>  arch/arm/plat-omap/include/plat/usb.h      |    3 -
>>  drivers/mfd/omap-usb-host.c                |  733 +++++++++++-----------------
>>  drivers/usb/host/ehci-omap.c               |   17 +-
>>  drivers/usb/host/ohci-omap3.c              |   18 +-
>>  9 files changed, 891 insertions(+), 558 deletions(-)
>>
>>
>
> Hi Benoit Cousson
>                   please ack this series; I am waiting for your ack
> to lineup this USBHS runtime pm adaptions.
>
> regards
> keshava

Hi Benoit Cousson
               please ack this series; kevin has already given review
by for the Runtime pm adaptations;
balbi has recommended for you ack ; so,I request please give you ack
by so that sameo can take these
patches from my git tree : git://gitorious.org/~kmg/mirrors/kmg-usbhs-pm.git

regards
keshava
