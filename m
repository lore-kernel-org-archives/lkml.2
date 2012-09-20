Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2ITDVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 23:21:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48701 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab2ITDVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 23:21:39 -0400
Message-ID: <505A8BAB.2020004@ti.com>
Date: Thu, 20 Sep 2012 05:21:15 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <tony@atomide.com>, <linux@arm.linux.org.uk>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] ARM: dts: omap: add dt data for MUSB
References: <1348047128-25692-1-git-send-email-kishon@ti.com>
In-Reply-To: <1348047128-25692-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 09/19/2012 11:32 AM, Kishon Vijay Abraham I wrote:
> This patch series adds dt data to get MUSB working in omap4 and omap3
> 
> Changes from v2:
> * Changes the subject of all the patches to include "ARM: dts:"
> * Added reg property and interrupt property for "usb_otg_hs". Previously these
>   were obtained from ti,hwmods property.
> * Rebased on
>   git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git devel-dt
> 
> Changes from v1:
> Just removed the omap-usb2 dt data and sent that as a separate patch.
> 
> Kishon Vijay Abraham I (3):
>   ARM: dts: Add twl6030-usb data
>   ARM: dts: Add twl4030-usb data
>   ARM: dts: omap: Add usb_otg and glue data

Thanks for the update. I've just pulled the series for 3.7.

Regards,
Benoit

