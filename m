Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0FHOk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 10:40:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49620 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab0FHOkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 10:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=qOrQhjOlHH/2f1DYff9xUDIql+t08sAfVbpMZzM0M1Sx0j8dLDg4ruD20doxHUnNpI
         KFSg+/BOZzqz5GyQk4JtkbEzVOxwH7KoW8mfxNVL3hnLs2dSCJMmTvdE10AwbG3FaIKt
         rqVis9VvPZPFgFGS4HntaTo9vpDZQk88cqOJc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikAP0zV6fldbT8N8F3QivdkdfrWFc2lJAj0K5aY@mail.gmail.com>
References: <fb74f066-a541-45e8-a4b5-bc0a9342f10e@t26g2000prt.googlegroups.com>
	<AANLkTikAP0zV6fldbT8N8F3QivdkdfrWFc2lJAj0K5aY@mail.gmail.com>
Date: Tue, 8 Jun 2010 22:34:33 +0800
Message-ID: <AANLkTinJeMKBzsBwgSLcHXtexM2oI3S97HO8IPri9EA7@mail.gmail.com>
Subject: Fwd: [rtc-linux] RTC_SET_TIME: Inappropriate ioctl for device
From: Wan ZongShun <mcuos.com@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-rtc <rtc-linux@googlegroups.com>, jeffjway@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC to LKML to do further discussion.

---------- Forwarded message ----------
From: Wan ZongShun <mcuos.com@gmail.com>
Date: 2010/6/8
Subject: Re: [rtc-linux] RTC_SET_TIME: Inappropriate ioctl for device
To: rtc-linux@googlegroups.com, jeffjway@gmail.com


Hi Jeff,

2010/6/8 JJeff <jeffjway@gmail.com>:
> Whenever I try to run 'hwclock', I get the error:
> "RTC_RD_TIME: Inappropriate ioctl for device:"
> or
> " RTC_SET_TIME: Inappropriate ioctl for device"
> if I run it with the -w option
>

Both of errors indicate your user layer or kernel driver is using a
wrong IOCTL command,
maybe your RTC_RD_TIME of user layer doesnot match the  RTC_RD_TIME of
kernel layer.
so driver return a '--ENOTTY' error no.

The better thing is you can write a rtc test application to identify
your driver works well.

Maybe you can change other version hwclock for testing.

> Is the hwclock too old a version or something?  The option --version
> is not recognised.
>
>
> I'm trying to use the hwclock command to sync the time each bootup, so
> any other ideas as to how to do it would be good too.
>
> Thanks
>
> Jeff
>
> --
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.



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
