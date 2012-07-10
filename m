Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab2GJHCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 03:02:31 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:41272 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072Ab2GJHC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 03:02:27 -0400
Message-ID: <4FFBD379.6070606@ti.com>
Date: Tue, 10 Jul 2012 12:32:17 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org, hvaibhav@ti.com
Subject: Re: [PATCH v1 07/11] drivers: usb: twl4030: Add device tree support
 for twl4030 usb
References: <1340884267-28908-1-git-send-email-kishon@ti.com>	<1340884267-28908-8-git-send-email-kishon@ti.com>	<4FFBC56F.7080007@ti.com> <CAAe_U6JhMWzsZ_XZzO0gt=g9fufL-urCLEC0nWfa8vk-9x6F_w@mail.gmail.com>
In-Reply-To: <CAAe_U6JhMWzsZ_XZzO0gt=g9fufL-urCLEC0nWfa8vk-9x6F_w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2012 12:22 PM, ABRAHAM, KISHON VIJAY wrote:
>>> +TWL4030 USB PHY AND COMPARATOR
>>> >>  + - compatible : Should be "ti,twl4030-usb"
>>> >>  + - interrupts : The interrupt numbers to the cpu should be specified.
>>> >>  First
>>> >>  +   interrupt number is the otg interrupt number that raises ID interrupts
>>> >>  +   and VBUS interrupts. The second interrupt number is optional.
>>> >>  + -<supply-name>-supply : phandle to the regulator device tree node.
>>> >>  +<supply-name>   should be vusb1v5, vusb1v8 and vusb3v1
>>> >>  + - usb_mode : The mode used by the phy to connect to the controller. "1"
>>> >>  +   specifies "ULPI" mode and "2" specifies "CEA2011_3PIN" mode.
>> >
>> >
>> >  Are these standard usb phy modes or something specific to the twl4030
>> >  usb phy?
> These are standard modes used to connect the phy to the controller. I
> think it's used by other chips other than twl4030 (Something in
> am35xx??).

So would it make sense to document these bindings independent of a given
phy and a given controller, so it could be reused and not duplicated in
various forms for various different controllers.
