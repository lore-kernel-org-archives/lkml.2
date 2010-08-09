Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab0HII7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:59:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63208 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab0HII7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=EJBAR0fzXdtz6VAoliwOsSsBOe0Cxt646OXsgAJMmHQ6csROhfmrcTojbpJ+xAqahw
         AHdunpchzF1/grG7GVHiyvK0rBp+Rk+YPEQBuoi1DajIjW406zcGM6uySydECHqouahH
         3oeZkpOvl7+yYcYElT8OVEF2SIavQ5j8IkamM=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1281342211.3035.1.camel@odin>
References: <1281053354.12131.4.camel@mola> <1281342211.3035.1.camel@odin>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 9 Aug 2010 16:59:16 +0800
Message-ID: <AANLkTikytMMSV=3eYYE2cwoFUYX6e8DzgeCVP-+=iBet@mail.gmail.com>
Subject: Re: [PATCH 1/2 RESEND] regulator: lp3971 - remove unnecessary ret 
	value checking in lp3971_i2c_write()
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/9 Liam Girdwood <lrg@slimlogic.co.uk>:
> On Fri, 2010-08-06 at 08:09 +0800, Axel Lin wrote:
>> We already check count value before calling i2c_smbus_read_byte_data(),
>> no need to check it again.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> ---
>> This resend adds regulator: prefix in the subject line.
>>
>>  drivers/regulator/lp3971.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
>> index d4d9822..3bb82b6 100644
>> --- a/drivers/regulator/lp3971.c
>> +++ b/drivers/regulator/lp3971.c
>> @@ -377,7 +377,7 @@ static int lp3971_i2c_read(struct i2c_client *i2c, char reg, int count,
>>       if (count != 1)
>>               return -EIO;
>>       ret = i2c_smbus_read_byte_data(i2c, reg);
>> -     if (ret < 0 || count != 1)
>> +     if (ret < 0)
>>               return -EIO;
>>
>>       *dest = ret;
>
> Applied 1/2 only as 2/2 is the same patch.
Ooops. My bad. I copied the same patch for patch 1/2 and 1/2.
I'll resend it now.
patch tiltle: [PATCH RESEND again] regulator: lp3971 - remove
unnecessary ret value checking in lp3971_i2c_write()

Regards,
Axel
