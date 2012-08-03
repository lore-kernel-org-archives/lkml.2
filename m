Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2HCOdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:33:19 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:33095 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab2HCOdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:33:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120803132852.GE8269@arwen.pp.htv.fi>
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
	<1343639400-28725-4-git-send-email-kishon@ti.com>
	<20120803132852.GE8269@arwen.pp.htv.fi>
Date: Fri, 3 Aug 2012 20:03:13 +0530
Message-ID: <CAAe_U6+HZfotZyf=YGf16hvNgZN5Pdk2zz+ywcFR71D=JxQ=XA@mail.gmail.com>
Subject: Re: [PATCH v6 03/11] drivers: usb: otg: make twl6030_usb as a
 comparator driver to omap_usb2
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: balbi@ti.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 3, 2012 at 6:58 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Jul 30, 2012 at 02:39:52PM +0530, Kishon Vijay Abraham I wrote:
>> All the PHY configuration other than VBUS, ID GND and OTG SRP are removed
>> from twl6030. The phy configurations are taken care by the dedicated
>> usb2 phy driver. So twl6030 is made as comparator driver for VBUS and
>> ID detection.
>>
>> Writing to control module which is now handled in omap2430.c should be
>> removed once a driver for control module is in place.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>
> This looks good for the time being. Do you think it has any hard
> dependencies on your new phy drivers, or can I apply this without those
> other patches ??

It has a hard dependency on usb2phy driver.

Thanks
Kishon
