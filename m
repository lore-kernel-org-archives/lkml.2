Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0IQPqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:46:42 -0400
Received: from mail.bspu.unibel.by ([195.50.2.21]:46563 "EHLO mail"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752350Ab0IQPql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:46:41 -0400
Message-ID: <4C938D9D.4070709@bspu.unibel.by>
Date: Fri, 17 Sep 2010 18:47:41 +0300
From: Dzianis Kahanovich <mahatma@bspu.unibel.by>
Reply-To: mahatma@eu.by
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b6pre) Gecko/20100902 SeaMonkey/2.1b1pre
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: i2c: Re: #2 (Re: More modaliases + patchtool))
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au> <4C936EA5.2040506@bspu.unibel.by> <20100917140647.GA18367@opensource.wolfsonmicro.com>
In-Reply-To: <20100917140647.GA18367@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown пишет:

>> + 1 attach for "next" branch.
> 
> Again, please try to follow the process in SubmittingPatches for sending
> patches.

One thing (patch) per message?

Yes, I just speculate in this point on fact there are same patch for "next"
branch and may be intrpreted as one ;). Sorry.

>> --- linux-2.6.36-rc4-git3/sound/soc/codecs/tlv320dac33.c	2010-09-17 12:30:31.000000000 +0300
>> +++ b/sound/soc/codecs/tlv320dac33.c	2010-09-17 12:39:07.801200070 +0300
>> @@ -1712,6 +1712,9 @@ static int __init dac33_module_init(void
>>  	}
>>  	return 0;
>>  }
>> +
>> +MODULE_DEVICE_TABLE(i2c, tlv320dac33_i2c_id);
>> +
> 
> This change is OK but should be moved next to the actual table.

This means - after:
static const struct i2c_device_id tlv320dac33_i2c_id[] = {
...
}

?

IMHO I just copyed style of some of (now not remember) module example in
script. OK.

Thanks, next time I will carry out your recomendations. But may be not in
script (2) - current way most simple and safe.

-- 
WBR, Dzianis Kahanovich AKA Denis Kaganovich, http://mahatma.bspu.unibel.by/
