Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0FGGU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 02:20:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41814 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab0FGGU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 02:20:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o3/qKs9NXIjGtAMePuNZquwmqlwIhgDc20dpcFc+X+uszf2qT2RBF9DejnyOzBc0pE
         AGFHDYq9WZZgEKf9xuuu/7b+Fmsm46FXPA2yV4Jt+DH9LeibYec7ityq6rDSdp+n5/m4
         Sazrv0HznjWh6LZnY5yiJSqntX2JBxokoGwP0=
MIME-Version: 1.0
In-Reply-To: <20100607052027.GG14583@jasper.tkos.co.il>
References: <0173f18c60cb4d1f8a0d123da6cd3cfca0224788.1275456869.git.baruch@tkos.co.il>
	<AANLkTimzq5zBEqrxzkm_D7trn7ikJX8yqny_6SogdIO6@mail.gmail.com>
	<20100607052027.GG14583@jasper.tkos.co.il>
Date: Mon, 7 Jun 2010 14:20:25 +0800
Message-ID: <AANLkTimtgqEU3M9rMEqGZuwuNHUD9yxMx70XlLWxkQ3F@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH] rtc: driver for the DryIce block found in 
	i.MX25 chips
From: Wan ZongShun <mcuos.com@gmail.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/7 Baruch Siach <baruch@tkos.co.il>:
> Hi Wan,
>
> On Sat, Jun 05, 2010 at 11:08:46PM +0800, Wan ZongShun wrote:
>> Some minor comments below:
>
> One question though.
>
>> > +/*
>> > + * read the seconds portion of the current time from the dryice time counter
>> > + */
>> > +static int dryice_rtc_read_time(struct device *dev, struct rtc_time *tm)
>> > +{
>> > +       struct imxdi_dev *imxdi = dev_get_drvdata(dev);
>> > +       unsigned long now;
>> > +
>> > +       now = __raw_readl(imxdi->ioaddr + DTCMR);
>> > +       rtc_time_to_tm(now, tm);
>> > +
>>
>> When we want to return a tm value, call rtc_valid_tm() to check the tm
>> that is a good habit.
>
> Isn't rtc_time_to_tm() guaranteed to produce a valid tm value?
>

Yes, it can.


>>
>> > +       return 0;
>> > +}
>
> baruch
>
> --
>                                                     ~. .~   Tk Open Systems
> =}------------------------------------------------ooO--U--Ooo------------{=
>   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
>



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
