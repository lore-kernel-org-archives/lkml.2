Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab0GOJpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 05:45:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47856 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842Ab0GOJpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V4A7WEX/pNQBlDGN+2xpUPCSWupgxgwCF1eBv/HabZ35IyWYa85xFakiU3gfBBJo/h
         mvQPs7Yqg9js7324qD8xrIROTje5FJyKAP5nib6FX60BjO/twEIfMORsXCuqzeCJBM6l
         Cl7GKX9yzPCjIFt8RRy1cQGQmJ5gnce60mG/s=
MIME-Version: 1.0
In-Reply-To: <4C3ED0E2.10905@sysgo.com>
References: <4C3ED0E2.10905@sysgo.com>
Date: Thu, 15 Jul 2010 17:45:09 +0800
Message-ID: <AANLkTinM2NZ1Bx_ONyPYZ37GlKjmtk3bjFNQfktlCOGJ@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH] Fix the rx8581 setdatetime
From: Wan ZongShun <mcuos.com@gmail.com>
To: linux-rtc <rtc-linux@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: Martyn Welch <martyn.welch@gefanuc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/15 Rudolf Marek <rudolf.marek@sysgo.com>:
> Hello,
>
> This patch fixes the logic while writing new date/time to the chip. The
> driver incorrectly written back register values to different registers
> and even with wrong mask. The patch adds clearing of the VLF register,
> which should be cleared if all date/time values are set.
>
> Signed-off-by: Rudolf Marek <rudolf.marek@sysgo.com>
>
> I'm attaching this as an attachment because Thunderbird will break it

Not everyone has time and willing to download your patch for reviewing,
so why not try to setting your Thunderbird to solve this break?

Anyway, this is a good patch, thanks!

Acked-by: Wan ZongShun <mcuos.com@gmail.com>

> otherwise.
> For your reference, datasheet is here:
>
> http://www.epsontoyocom.co.jp/english/product/RTC/set03/ra8581sa/index.html
>
> Thanks,
> Rudolf
>
> --
>
> S přátelským pozdravem / Best regards / Mit freundlichen Grüßen
>
> Ing. Rudolf Marek
> SYSGO s.r.o.
> Zelený pruh 99
> CZ-14800 Praha 4
> Phone: +420 222138 627, +49 6136 9948 627
> Fax: +420 296374890, +49 6136 9948 1 627
> rudolf.marek@sysgo.com
>
> http://www.sysgo.com | http://www.elinos.com | http://www.pikeos.com
>
> --
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.
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
