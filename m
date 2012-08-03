Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2HCOjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:39:48 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:56960 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409Ab2HCOjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:39:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120803133122.GG8269@arwen.pp.htv.fi>
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
	<1343639400-28725-6-git-send-email-kishon@ti.com>
	<20120803133122.GG8269@arwen.pp.htv.fi>
Date: Fri, 3 Aug 2012 20:09:43 +0530
Message-ID: <CAAe_U6JVcyiugeLtsK_15jTf5c7edCjAUZ=N1hoJJffpFr2_MQ@mail.gmail.com>
Subject: Re: [PATCH v6 05/11] drivers: usb: twl6030: Add dt support for
 twl6030 usb
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

On Fri, Aug 3, 2012 at 7:01 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Jul 30, 2012 at 02:39:54PM +0530, Kishon Vijay Abraham I wrote:
>> Add device tree support for twl6030 usb driver.
>> Update the Documentation with device tree binding information.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>
> This looks great too. I can take this without any dependencies on the
> rest of the series, I believe. Right ??

I think it might not apply cleanly without [PATCH v6 03/11] drivers:
usb: otg: make twl6030_usb as a comparator driver to omap_usb2.

Thanks
Kishon
