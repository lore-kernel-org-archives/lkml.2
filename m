Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1IMH5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 03:57:07 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:56656
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752644Ab1IMH5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 03:57:05 -0400
Message-ID: <4E6F0CC7.7040208@compulab.co.il>
Date: Tue, 13 Sep 2011 10:56:55 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Li Yang <leoli@freescale.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Felipe Balbi <balbi@ti.com>,
        Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: [PATCHv4 00/19] First round in OTG rework
References: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com> <20110912121255.GA2520@xps8300>
In-Reply-To: <20110912121255.GA2520@xps8300>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/11 15:12, Heikki Krogerus wrote:
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
>>   usb: otg: Rename otg_transceiver to usb_phy
>>   usb: otg: Rename usb_otg and usb_xceiv to usb_phy
>>   usb: otg: Separate otg members from usb_phy
>>   usb: otg: ab8500: Start using struct usb_otg
>>   usb: otg: fsl: Start using struct usb_otg
>>   usb: otg: gpio_vbus: Start using struct usb_otg
>>   usb: otg: isp1301_omap: Start using struct usb_otg
>>   usb: otg: msm: Start using struct usb_otg
>>   usb: otg: langwell: Start using struct usb_otg
>>   usb: otg: nop: Start using struct usb_otg
>>   usb: otg: twl4030: Start using struct usb_otg
>>   usb: otg: twl6030: Start using struct usb_otg
>>   usb: otg: ulpi: Start using struct usb_otg
>>   arm: imx: Start using struct usb_otg
>>   usb: musb: Start using struct usb_otg
>>   power_supply: Convert all users to new usb_phy
>>   usb: Convert all users to new usb_phy
>>   usb: otg: Remove OTG specific members from usb_phy
>>   usb: otg: Convert all users to pass struct usb_otg for OTG functions
> 
> You guys are maintainers of the tranceiver/otg drivers. Can you test
> these and ACK the patch for your driver if you feel there is nothing
> wrong with these? I would much appreciate.
> 

Currently, I cannot test this on my PXA3xx board, but I went through
the patches and it looks fine.
So,

Acked-by: Igor Grinberg <grinberg@compulab.co.il>

for:
pxa3xx and drivers/usb/otg/ulpi.c

Would be nice to have the Acked/Tested-by from iMX guys.

-- 
Regards,
Igor.
