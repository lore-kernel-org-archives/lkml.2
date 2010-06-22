Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993Ab0FVJDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 05:03:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48310 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab0FVJDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vEn/p77nkGrq/xE0rUA1jlQouCsehxylqNS5Yui/B/+qeIsA7DTXC2wH2S5O8QOGOt
         OCDq0u4qzFhromkdIXeREgGSQAm1feESPrrxbna3FjpWGvpd1FHGyAPAszcoKOe2fItR
         xUWuUgi7JwUsADKoadKGLxg05Umd1LZk6jXg0=
MIME-Version: 1.0
In-Reply-To: <4C1E898D.8010902@bluewatersys.com>
References: <1276562699-4933-1-git-send-email-ryan@bluewatersys.com> 
	<4C1E898D.8010902@bluewatersys.com>
From: CoffBeta <coffbeta@gmail.com>
Date: Tue, 22 Jun 2010 17:03:04 +0800
Message-ID: <AANLkTilvJqugUmHXbdsXSOqt1uixJOYKKtEplFavvggG@mail.gmail.com>
Subject: Re: [PATCH] ds2782: Fix ds2782_get_capacity return value
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, mike@compulab.co.il,
       linux-kernel@vger.kernel.org, vilensky@compulab.co.il,
       mike.rapoport@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

confirm

On Mon, Jun 21, 2010 at 05:35, Ryan Mallon <ryan@bluewatersys.com> wrote:
> On 06/15/2010 12:44 PM, Ryan Mallon wrote:
>> The ds2782_get_capacity function should return 0 on success, not the
>> capacity value.
>>
>> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
>> ---
>>  drivers/power/ds2782_battery.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
>> index d762a0c..2afbeec 100644
>> --- a/drivers/power/ds2782_battery.c
>> +++ b/drivers/power/ds2782_battery.c
>> @@ -163,7 +163,7 @@ static int ds2782_get_capacity(struct ds278x_info *info, int *capacity)
>>       if (err)
>>               return err;
>>       *capacity = raw;
>> -     return raw;
>> +     return 0;
>>  }
>>
>>  static int ds2786_get_current(struct ds278x_info *info, int *current_uA)
>
> Ping, Anton?
>
> ~Ryan
>
> --
> Bluewater Systems Ltd - ARM Technology Solution Centre
>
> Ryan Mallon                     5 Amuri Park, 404 Barbadoes St
> ryan@bluewatersys.com           PO Box 13 889, Christchurch 8013
> http://www.bluewatersys.com     New Zealand
> Phone: +64 3 3779127            Freecall: Australia 1800 148 751
> Fax:   +64 3 3779135                      USA 1800 261 2934
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
