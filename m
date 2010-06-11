Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0FKFw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:52:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49045 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab0FKFw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:52:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bR053iLg3yr2KCxWACaK/8B1bSKGFP3su9cic0emy5mCyoI50KGvfac58IEnRNiYYk
         rqz8/nVTiX0RDXjoQrhsHMj/xqJVe1aEzUxMj+hCSuyR4JuddVLNmpx/1UBv7RmGwHXI
         UDwz5MoFS+NocOGz40j+j4vxgynVO43l6RMUQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinpth-JO7pIOWXbnuUWXM3xQ1OnFKkfESwi0cP3@mail.gmail.com>
References: <1275647794-30634-1-git-send-email-kgene.kim@samsung.com>
	<1275647794-30634-2-git-send-email-kgene.kim@samsung.com>
	<AANLkTinpth-JO7pIOWXbnuUWXM3xQ1OnFKkfESwi0cP3@mail.gmail.com>
Date: Fri, 11 Jun 2010 14:52:56 +0900
X-Google-Sender-Auth: JYig9RCX7cIUhzcB2-XPQlCLgxU
Message-ID: <AANLkTikygrbXPkszVvBpH217mOaY8UzJE8zcOGVTGRZo@mail.gmail.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: add maintainer for SAMSUNG ARM 
	ARCHITECTURES
From: Kyungmin Park <kmpark@infradead.org>
To: ben-linux@fluff.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

On Sat, Jun 5, 2010 at 11:24 AM, Kyungmin Park <kmpark@infradead.org> wrote:
> Hi Ben,
>
> I'm waiting your comments.
>
> Thank you,
> Kyungmin Park
>
> On Fri, Jun 4, 2010 at 7:36 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
>> ---
>>  MAINTAINERS |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 1d41149..f4e4c61 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -896,11 +896,13 @@ S:        Maintained
>>
>>  ARM/SAMSUNG ARM ARCHITECTURES
>>  M:     Ben Dooks <ben-linux@fluff.org>
>> +M:     Kukjin Kim <kgene.kim@samsung.com>
>>  L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>>  W:     http://www.fluff.org/ben/linux/
>>  S:     Maintained
>>  F:     arch/arm/plat-samsung/
>>  F:     arch/arm/plat-s3c24xx/
>> +F:     arch/arm/plat-s5p/
>>
>>  ARM/S3C2410 ARM ARCHITECTURE
>>  M:     Ben Dooks <ben-linux@fluff.org>
>> --
>> 1.6.2.5
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
>
