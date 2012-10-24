Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934706Ab2JXLKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:10:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39155 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933804Ab2JXLKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:10:49 -0400
Message-ID: <5087CCA8.9020906@ti.com>
Date: Wed, 24 Oct 2012 16:40:32 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>, Constantine Shulyupin <const@MakeLinux.com>
CC: <gregkh@linuxfoundation.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] usb: remove CONFIG_USB_MUSB_HOST etc
References: <1349702227-24875-1-git-send-email-const@MakeLinux.com> <50868EED.7050909@ti.com> <20121023123927.GB29281@arwen.pp.htv.fi>
In-Reply-To: <20121023123927.GB29281@arwen.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 6:09 PM, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Oct 23, 2012 at 06:04:53PM +0530, Sekhar Nori wrote:
>> On 10/8/2012 6:47 PM, Constantine Shulyupin wrote:
>>> From: Constantine Shulyupin <const@MakeLinux.com>
>>>
>>> Remove USB configuration in arch/arm/mach-davinci/usb.c accordingly 
>>> CONFIG_USB_MUSB_OTG CONFIG_USB_MUSB_PERIPHERAL CONFIG_USB_MUSB_HOST 
>>> and set MUSB_OTG configuration by default
>>> because this configuration options are removed from Kconfig.
>>>
>>> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
>>
>> Queuing this patch for v3.8. Since the config options are removed there
>> is no use having code which refers to them. The patch has been tested on
>> DM644x and DM365 in both host and gadget mode (I will add this
>> information to commit text while committing). Without this patch .mode
>> seems to be defaulting to MUSB_UNDEFINED which I think is definitely wrong.
> 
> sorry for the delay, this looks ok:
> 
> Acked-by: Felipe Balbi <balbi@ti.com>

Thanks Felipe, I added your ack.

Constantine,

Patches touching arch/arm/* should be prefixed with 'ARM:' and those
touching mach-davinci should be prefixed with 'davinci:'. I added these
two while committing the patch this time. Please take care next time on.

Thanks,
Sekhar
