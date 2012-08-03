Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2HCOmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:42:17 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:60068 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754091Ab2HCOmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:42:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120803133431.GK8269@arwen.pp.htv.fi>
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
	<1343639400-28725-10-git-send-email-kishon@ti.com>
	<20120803133431.GK8269@arwen.pp.htv.fi>
Date: Fri, 3 Aug 2012 20:12:07 +0530
Message-ID: <CAAe_U6+fMyck-EyicDuwKx-HggMJFEbAHTO9+8PELgHNBL1nFA@mail.gmail.com>
Subject: Re: [PATCH v6 09/11] drivers: usb: musb: Add device tree support for
 omap musb glue
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

On Fri, Aug 3, 2012 at 7:04 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Jul 30, 2012 at 02:39:58PM +0530, Kishon Vijay Abraham I wrote:
>> Added device tree support for omap musb driver and updated the
>> Documentation with device tree binding information.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>
> This looks good and I think I can take this without any dependencies
> again. Correct ?

correct.

Thanks
Kishon
