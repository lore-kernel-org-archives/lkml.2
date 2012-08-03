Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2HCOhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:37:54 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:51434 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575Ab2HCOhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:37:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120803132945.GF8269@arwen.pp.htv.fi>
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
	<1343639400-28725-5-git-send-email-kishon@ti.com>
	<20120803132945.GF8269@arwen.pp.htv.fi>
Date: Fri, 3 Aug 2012 20:07:49 +0530
Message-ID: <CAAe_U6Lm3v-g64QmWzJJs_mZ-Qy4_YK5WKnt_B-P7sbRDNq=Jg@mail.gmail.com>
Subject: Re: [PATCH v6 04/11] arm: omap: hwmod: add a new addr space in otg
 for writing to control module
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

On Fri, Aug 3, 2012 at 6:59 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Mon, Jul 30, 2012 at 02:39:53PM +0530, Kishon Vijay Abraham I wrote:
>> The mailbox register for usb otg in omap is present in control module.
>> On detection of any events VBUS or ID, this register should be written
>> to send the notification to musb core.
>>
>> Till we have a separate control module driver to write to control module,
>> omap2430 will handle the register writes to control module by itself. So
>> a new address space to represent this control module register is added
>> to usb_otg_hs.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>
> this should come before previous patch, right ? Otherwise we will try to
> ioremap a resource which isn't passed down to driver. No ?

right. Will change the order in my next series.

Thanks
Kishon
