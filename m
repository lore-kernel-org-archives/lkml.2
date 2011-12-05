Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1LELvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:51:46 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:21934 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab1LELvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:51:45 -0500
Message-ID: <4EDCB040.1050305@atmel.com>
Date: Mon, 05 Dec 2011 12:51:28 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Jamie Iles <jamie@jamieiles.com>
CC: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/macb: add DT support
References: <20111202153832.GA4998@totoro> <1322846050-4543-1-git-send-email-nicolas.ferre@atmel.com> <20111202172854.GB4998@totoro> <4ED910B6.7080000@atmel.com> <20111205114838.GC21006@totoro>
In-Reply-To: <20111205114838.GC21006@totoro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 12:48 PM, Jamie Iles :
> On Fri, Dec 02, 2011 at 06:53:58PM +0100, Nicolas Ferre wrote:
>> On 12/02/2011 06:28 PM, Jamie Iles :
> [...]
>>> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
>>> index 103c6e6..89060e6 100644
>>> --- a/drivers/net/ethernet/cadence/macb.c
>>> +++ b/drivers/net/ethernet/cadence/macb.c
>>> @@ -1247,6 +1247,8 @@ static const struct of_device_id macb_dt_ids[] = {
>>>   	{ .compatible = "cdns,at32ap7000-macb" },
>>>   	{ .compatible = "cdns,at91sam9260-macb" },
>>>   	{ .compatible = "cdns,macb" },
>>> +	{ .compatible = "cdns,pc302-gem" },
>>> +	{ .compatible = "cdns,gem" },
>>>   	{ /* sentinel */ }
>>>   };
>>
>> BTW, I think we may also modify the MII/RMII selection code for
>> adding gigabit selection... but maybe you already have the patches?
>
> No, I don't have access to a version of the GEM with gigabit support.
> The platforms I was working on used it as a 10/100 controller, but had
> to use the GEM to get hardware timestamping support.

Ok, Thanks for your feedback. I send a v3 patch now.

Best regards,
-- 
Nicolas Ferre
