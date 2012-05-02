Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2EBRqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:46:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46280 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab2EBRqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:46:35 -0400
Message-ID: <4FA172EF.6000304@us.ibm.com>
Date: Wed, 02 May 2012 10:46:23 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>,
        lkml <linux-kernel@vger.kernel.org>, "Bergmann, Arnd" <arnd@arndb.de>
Subject: Re: omap-usb-host.c compile error
References: <4FA056A1.1040209@us.ibm.com> <20120502074632.GG20224@sortiz-mobl>
In-Reply-To: <20120502074632.GG20224@sortiz-mobl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050217-7182-0000-0000-000001699972
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 12:46 AM, Samuel Ortiz wrote:
> Hi John,
>
> On Tue, May 01, 2012 at 02:33:21PM -0700, John Stultz wrote:
>> I've been seeing the following compile issue for a few -rcs now:
>> drivers/mfd/omap-usb-host.c: In function 'omap_usbhs_init':
>> drivers/mfd/omap-usb-host.c:524: error: implicit declaration of
>> function 'cpu_is_omap3430'
>> drivers/mfd/omap-usb-host.c:524: error: implicit declaration of
>> function 'omap_rev'
>> drivers/mfd/omap-usb-host.c:524: error: 'OMAP3430_REV_ES2_1'
>> undeclared (first use in this function)
>> drivers/mfd/omap-usb-host.c:524: error: (Each undeclared identifier
>> is reported only once
>> drivers/mfd/omap-usb-host.c:524: error: for each function it appears in.)
>>
>> Reverting 1fcb57d0f6e1150003d222051aaaf4bc4a9ccc94 seems to resolve it.
>>
>> This still isn't fixed in Linus' HEAD. Any plans here?
> I pushed the fixed to my for-linus branch yesterday. I'll send a pull request
> to Linus in time for rc6.
>

Thanks!
-john

