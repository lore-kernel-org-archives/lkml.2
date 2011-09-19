Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1ISOBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 10:01:30 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:46996 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182Ab1ISOB2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 10:01:28 -0400
MIME-Version: 1.0
In-Reply-To: <20110919135653.GR32263@sortiz-mobl>
References: <1316092970-2440-1-git-send-email-keshava_mgowda@ti.com>
	<20110919135653.GR32263@sortiz-mobl>
Date: Mon, 19 Sep 2011 19:31:23 +0530
Message-ID: <CAP05o4+AYs07JLio7NgSUOuzSTqiZA45WPDPqAB55u=02vHYWA@mail.gmail.com>
Subject: Re: [PATCH 0/5 v9] mfd: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, b-cousson@ti.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        parthab@india.ti.com, tony@atomide.com, khilman@ti.com, paul@pwsan.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 7:26 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Keshava,
>
> On Thu, Sep 15, 2011 at 06:52:45PM +0530, Keshava Munegowda wrote:
>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>
>> The Hwmod structures and Runtime PM features are implemented
>> For EHCI and OHCI drivers of OMAP3 and OMAP4.
>> The global suspend/resume of EHCI and OHCI
>> is validated on OMAP3430 sdp board with these patches.
>>
>> these patches are rebased to kevin's pm branch and
>> usbhs latest mainline kernel patches
>
> I'm ready to apply this one to my MFD for-next branch. Or do you want it to go
> through Kevin's tree ?
>
> Cheers,
> Samuel


Thanks samuel;
But, patch 1 and 2 requires benoit causson's ack by;
so , I am waiting for benoit response on this.

please wait till I will cofirm for the merge; As of now, kevin and
balbi are OK with these patches,
benoit's confirmation/comments  are pending.

Thanks and regards
keshava




>
>
>> TODO:
>>    - Adding pad configurations to Hwmods
>>    - Aggressive clock cutting in usb bus suspends
>>    - Remote Wakeup implementation using irq-chaining
>>
>>
>> Benoit Cousson (1):
>>   arm: omap: usb: ehci and ohci hwmod structures for omap4
>>
>> Keshava Munegowda (4):
>>   arm: omap: usb: ehci and ohci hwmod structures for omap3
>>   arm: omap: usb: register hwmods of usbhs
>>   arm: omap: usb: device name change for the clk names of usbhs
>>   mfd: omap: usb: Runtime PM support
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
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
>
