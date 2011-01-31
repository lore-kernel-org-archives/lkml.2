Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1AaUtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:49:40 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:61784 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753544Ab1AaUtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:49:39 -0500
Message-ID: <4D4720BA.1050307@metafoo.de>
Date: Mon, 31 Jan 2011 21:51:06 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH] bq27x00_battery: Add new properties
References: <20110131135147.GB3883@oksana.dev.rtsoft.ru> <20110131154354.GC3819@enneenne.com> <20110131160321.GA23546@oksana.dev.rtsoft.ru> <AANLkTikr3LL-+4LObBaCTo7JGTFTRdVbpbbUH4nfJ28X@mail.gmail.com> <4D470B42.7050301@metafoo.de> <20110131192242.GB23722@sirena.org.uk> <AANLkTi=zc_Ft6K=QP70-fUASO+0pO_2O8Cp6W6LL08MS@mail.gmail.com> <20110131193810.GK5123@opensource.wolfsonmicro.com> <AANLkTinWiG=v-Mwt+tBBSFN43w4f0qifmr+v=mArB0u0@mail.gmail.com> <AANLkTi=ySBY3=-kyL0x3GbzmNELWi7Ot=nivuVVwHov6@mail.gmail.com> <20110131201555.GA31249@oksana.dev.rtsoft.ru>
In-Reply-To: <20110131201555.GA31249@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 09:15 PM, Anton Vorontsov wrote:
> On Mon, Jan 31, 2011 at 09:04:32PM +0100, Pali Rohár wrote:
>> This patch adds MODULE_DEVICE_TABLE for module bq27x00_battery.
>>
>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> Tested-by: Pali Rohár <pali.rohar@gmail.com>
> 
> Lars, if that's OK for you, please take Pali's patches via your
> tree. I can merge it into battery-2.6.git on request (and after
> review, of course).
> 
> Thanks!
> 

I'll do. Thanks

- Lars

>>
>> --- a/drivers/power/bq27x00_battery.c   2011-01-31 20:58:11.000000000 +0100
>> +++ b/drivers/power/bq27x00_battery.c   2011-01-31 20:57:05.000000000 +0100
>> @@ -596,6 +596,7 @@ static const struct i2c_device_id bq27x0
>>         { "bq27500", BQ27500 },
>>         {},
>>  };
>> +MODULE_DEVICE_TABLE(i2c, bq27x00_id);
>>
>>  static struct i2c_driver bq27x00_battery_driver = {
>>         .driver = {
> 

