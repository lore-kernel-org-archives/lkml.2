Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab1JKQFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:05:05 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:50464 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab1JKQFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:05:04 -0400
Message-ID: <4E946923.1010202@atmel.com>
Date: Tue, 11 Oct 2011 18:04:51 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] tty/serial: atmel_serial: add device tree support
References: <1317635502-9430-1-git-send-email-nicolas.ferre@atmel.com> <4E8A6858.6020700@gmail.com> <4E8AC171.4020706@atmel.com> <4E8B054B.3060506@gmail.com> <20111004165520.GB10919@ponder.secretlab.ca>
In-Reply-To: <20111004165520.GB10919@ponder.secretlab.ca>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 06:55 PM, Grant Likely :
> On Tue, Oct 04, 2011 at 08:08:27AM -0500, Rob Herring wrote:
>> Nicolas,
>>
>> On 10/04/2011 03:18 AM, Nicolas Ferre wrote:
>>> On 10/04/2011 03:58 AM, Rob Herring :
>>>> On 10/03/2011 04:51 AM, Nicolas Ferre wrote:
>>>>> +Optional properties:
>>>>> +- atmel,use-dma-rx: use of PDC or DMA for receiving data
>>>>> +- atmel,use-dma-tx: use of PDC or DMA for transmitting data
>>>>
>>>> Is this an internal DMA or separate DMA controller? If the latter, these
>>>> should be phandles to a DMA channel/request.
>>>
>>> Well, for now it relies on PDC (looks like an internal DMA). There is no
>>> notion of channel/request so I think it is appropriate to keep it like this.
>>>
>>
>> Okay. Although, this is a bit of Linux creeping into DT. DT should
>> describe the h/w. You should really be describing whether the h/w
>> supports DMA or not rather than whether you want to use DMA or not.
>> Since DMA support is really tied to the SOC rather than board, you could
>> just use the compatible string to distinguish platforms that support DMA
>> or not. So what is determining this setting? Is it purely user choice?
> 
> It is okay for a binding to still requires config properties like this
> to state if the DMA can be used, even if compatible is enough to
> distinquish.  However, you're right to bring it up.  It is a design
> choice that should be made thoughtfully.

Grant, Rob,

Thanks for your inputs.

I would like to keep this binding to allow the user to choose the way he
likes to use integrated DMA.

I plan to resend a patch series about this serial driver once I will be
able to propose a rs485 binding.

Cheers,
-- 
Nicolas Ferre
