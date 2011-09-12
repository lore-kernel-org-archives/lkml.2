Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1ILMpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 08:45:18 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:38735 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771Ab1ILMpQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 08:45:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110912121255.GA2520@xps8300>
References: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>
	<20110912121255.GA2520@xps8300>
Date: Mon, 12 Sep 2011 18:15:15 +0530
Message-ID: <CAAe_U6LXt+f-xf7iO7xP6G7A3qZDnptQFJOHwS1UBeq0XTCyjg@mail.gmail.com>
Subject: Re: [PATCHv4 00/19] First round in OTG rework
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Li Yang <leoli@freescale.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Felipe Balbi <balbi@ti.com>,
        Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested your patches in OMAP4 which has twl6030.

Tested-by: Kishon Vijay Abraham I <kishon@ti.com>

On Mon, Sep 12, 2011 at 5:42 PM, Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
> Hi guys,
>
> On Wed, Sep 07, 2011 at 10:15:53AM +0300, Heikki Krogerus wrote:
>> There were no comments in two weeks, so I'm dropping the RFC.
>> Otherwise this is the same as the previous, no changes.
>>
>> Quick summary:
>> This introduces struct usb_phy and struct usb_otg that
>> replace struct otg_transceiver. The transceiver and phy
>> members from struct otg_transceiver are left in struct
>> usb_phy and otg specific members are moved to struct
>> usb_otg.
>>
>> So the idea is simply to separate USB PHY handling from OTG.
>>
>> Heikki Krogerus (19):
>>   usb: otg: Rename otg_transceiver to usb_phy
>>   usb: otg: Rename usb_otg and usb_xceiv to usb_phy
>>   usb: otg: Separate otg members from usb_phy
>>   usb: otg: ab8500: Start using struct usb_otg
>>   usb: otg: fsl: Start using struct usb_otg
>>   usb: otg: gpio_vbus: Start using struct usb_otg
>>   usb: otg: isp1301_omap: Start using struct usb_otg
>>   usb: otg: msm: Start using struct usb_otg
>>   usb: otg: langwell: Start using struct usb_otg
>>   usb: otg: nop: Start using struct usb_otg
>>   usb: otg: twl4030: Start using struct usb_otg
>>   usb: otg: twl6030: Start using struct usb_otg
>>   usb: otg: ulpi: Start using struct usb_otg
>>   arm: imx: Start using struct usb_otg
>>   usb: musb: Start using struct usb_otg
>>   power_supply: Convert all users to new usb_phy
>>   usb: Convert all users to new usb_phy
>>   usb: otg: Remove OTG specific members from usb_phy
>>   usb: otg: Convert all users to pass struct usb_otg for OTG functions
>
> You guys are maintainers of the tranceiver/otg drivers. Can you test
> these and ACK the patch for your driver if you feel there is nothing
> wrong with these? I would much appreciate.
>
> Thanks,
>
> --
> heikki
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
