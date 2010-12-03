Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0LCFuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 00:50:54 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:52629 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0LCFux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 00:50:53 -0500
In-Reply-To: <20101203015914.GC20097@trinity.fluff.org>
References: <1290960420-7484-1-git-send-email-aaro.koskinen@iki.fi> <20101203015914.GC20097@trinity.fluff.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4284E5DA-DFF5-4507-9633-57EDD5FAA4E4@iki.fi>
Cc: ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] i2c-iop3xx: add iomem annotation
Date: Fri, 3 Dec 2010 07:51:10 +0200
To: Ben Dooks <ben-i2c@fluff.org>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 3.12.2010, at 3.59, Ben Dooks wrote:
> On Sun, Nov 28, 2010 at 06:07:00PM +0200, Aaro Koskinen wrote:
>> Eliminate unnecessary casts and the following sparse warnings:
[...]
>> --- a/drivers/i2c/busses/i2c-iop3xx.h
>> +++ b/drivers/i2c/busses/i2c-iop3xx.h
>> @@ -97,7 +97,7 @@
>>  #define	IOP3XX_I2C_IO_SIZE	0x18
>>
>>  struct i2c_algo_iop3xx_data {
>> -	u32 ioaddr;
>> +	char __iomem *ioaddr;
>
> probably should be changed to void if possible without creating extra
> warnings.

Yes, the updated patch is here: https://patchwork.kernel.org/patch/ 
363512/

A.

