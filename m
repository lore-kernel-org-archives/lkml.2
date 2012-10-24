Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964991Ab2JXKJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:09:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49852 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684Ab2JXKJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:09:49 -0400
Message-ID: <5087BE61.6060704@ti.com>
Date: Wed, 24 Oct 2012 12:09:37 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sebastien Guiriec <s-guiriec@ti.com>
CC: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH v3 0/4] ARM: dts: Update OMAP5 with address space and
 interrupts
References: <1351062434-22514-1-git-send-email-s-guiriec@ti.com> <5087B196.7090804@ti.com> <5087B47B.8080009@ti.com>
In-Reply-To: <5087B47B.8080009@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 11:27 AM, Sebastien Guiriec wrote:
> Hi Benoit,
> 
> On 10/24/2012 11:15 AM, Benoit Cousson wrote:
>> Hi Seb,
>>
>> Sorry, I missed your previous email, your v2 was the right one.
>> We do have a single INTC in every OMAP, there is no point to repeat the
>> same data hundred times.
>> The DTS are already big enough.
> 
> So in such case we should send a series for audio IP interrupt-parent
> removal for OMAP3/4/5 dtsi file in order to be coherent.

Yes. AM33xx was as well using that in some other IPs.

> Do you want me to do it?

Thanks, but I've just done the patch, I'll sent it in a couple of minutes.

Benoit

> 
>>
>> On 10/24/2012 09:07 AM, Sebastien Guiriec wrote:
>>> Since kernel 3.7 the DTS data are not overwriten by hwmod data we can
>>> add the address space
>>> and interrupt line description inside dtsi file for OMAP5. This serie
>>> is updating the
>>> current OMAP5 IP with missing entry.
>>>
>>> It has been tested on OMAP5 with 3.7-audio-display feature tree.
>>> - MMC is probing and functional
>>> - TWL6041 probing (GPIO/I2C)
>>> - booting (UART)
>>>
>>> Update since v1:
>>> - Add Ack and review
>>> - Fix up commit messages.
>>>
>>> Update since v2:
>>> - Add interrupt-parent.
>>
>> I will take the previous one to avoid the duplication of attributes.
>>
>> On top of that I will remove the ones introduce in audio IPs for
>> consistency on OMAP3/4/5 platforms.
>>
>> Regards,
>> Benoit
>>
> 

