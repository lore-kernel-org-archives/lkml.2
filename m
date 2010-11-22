Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab0KVOUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:20:20 -0500
Received: from mail.bspu.unibel.by ([195.50.2.21]:42400 "EHLO mail.bspu.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752302Ab0KVOUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:20:17 -0500
Message-ID: <4CEA7D13.9070602@bspu.unibel.by>
Date: Mon, 22 Nov 2010 16:24:19 +0200
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b7pre) Gecko/20101111 Firefox/4.0b7pre SeaMonkey/2.1b1
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, mahatma@eu.by,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] viafb: I2C/DDC LCD detection for VIA framebuffer
References: <4CEA62BB.9040403@bspu.unibel.by> <20101122135939.GA8882@bicker>
In-Reply-To: <20101122135939.GA8882@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for mistake. I sure to remove "const" but revert to older code later. I
repost fixed patch ("v2") to avoid formal problems. Sorry.

Dan Carpenter wrote:
> On Mon, Nov 22, 2010 at 02:31:55PM +0200, Dzianis Kahanovich wrote:
>> +static void via_i2c_detect(void)
>> +{
>> +	const u8 *edid;
>         ^^^^^
> 
>> +free_edid:
>> +		kfree(edid);
>                 ^^^^^^^^^^^
> 
> That probably shouldn't be const.
> 
>> +		if (n > 1)
>> +			break;
>> +	}
>> +}
>> +
>>
> 
> regards,
> dan carpenter
> 
> 


-- 
WBR, Dzianis Kahanovich AKA Denis Kaganovich, http://mahatma.bspu.unibel.by/
