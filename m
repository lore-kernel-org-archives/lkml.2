Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab3AJGT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 01:19:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49682 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab3AJGTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 01:19:55 -0500
Message-ID: <50EE5D61.1020307@ti.com>
Date: Thu, 10 Jan 2013 11:49:13 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Benoit Cousson <b-cousson@ti.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] ARM: dts: omap: add dt data for MUSB
References: <1348047128-25692-1-git-send-email-kishon@ti.com> <505A8BAB.2020004@ti.com> <20121227183524.GB7097@blackmetal.musicnaut.iki.fi>
In-Reply-To: <20121227183524.GB7097@blackmetal.musicnaut.iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 December 2012 12:05 AM, Aaro Koskinen wrote:
> Hi,
>
> On Thu, Sep 20, 2012 at 05:21:15AM +0200, Benoit Cousson wrote:
>> On 09/19/2012 11:32 AM, Kishon Vijay Abraham I wrote:
>>> This patch series adds dt data to get MUSB working in omap4 and omap3
>>>
>>> Changes from v2:
>>> * Changes the subject of all the patches to include "ARM: dts:"
>>> * Added reg property and interrupt property for "usb_otg_hs". Previously these
>>>    were obtained from ti,hwmods property.
>>> * Rebased on
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git devel-dt
>>>
>>> Changes from v1:
>>> Just removed the omap-usb2 dt data and sent that as a separate patch.
>>>
>>> Kishon Vijay Abraham I (3):
>>>    ARM: dts: Add twl6030-usb data
>>>    ARM: dts: Add twl4030-usb data
>>>    ARM: dts: omap: Add usb_otg and glue data
>>
>> Thanks for the update. I've just pulled the series for 3.7.
>
> I wonder what happened to the patch #3 (Add usb_otg and glue data)
> of this series? Why was it dropped? I cannot see it in 3.7 or 3.8-rc1.

Benoit?

-Kishon
