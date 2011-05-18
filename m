Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1ERFGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:06:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62741 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab1ERFF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:05:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=B4AQ+HhMXZtmlLzB+vvxzFe6clI28bgElx70bBPfsUS/Cgbi7/hwraMEJHYT4k5WHd
         MOHxv1Q+FhWqYA8u4OGBrgpqkB8JFAnKzcVjF6RdvdYCdcLZWPZuRDWgYxKDmrPBZfzI
         WDMHtcfDWDPTwBRQiR3dVtEOMBOoUlVj4S0l0=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <204176.97974.qm@web120507.mail.ne1.yahoo.com>
References: <204176.97974.qm@web120507.mail.ne1.yahoo.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 18 May 2011 13:05:38 +0800
Message-ID: <BANLkTikOEPBNN1FiPB1TcQr0oc2u9BpOGw@mail.gmail.com>
Subject: Re: [PATCH v2] rtc: rtc-ds1390/rtc-ds3234/rtc-m41t94: eliminate
 compile warning
To: Dennis Aberilla <denzzzhome@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Mark Jackson <mpfj@mimc.co.uk>,
        "Kim B. Heino" <Kim.Heino@bluegiga.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Dennis,

2011/5/18 Dennis Aberilla <denzzzhome@yahoo.com>:
> From: Axel Lin <axel.lin@gmail.com>
>
> These drivers are registered as spi drivers,
> thus use spi_get_drvdata instead of platform_get_drvdata.
>
> This patch eliminates the following compile warning:
> drivers/rtc/rtc-ds1390.c: In function 'ds1390_remove':
> drivers/rtc/rtc-ds1390.c:161: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type
> drivers/rtc/rtc-ds3234.c: In function 'ds3234_remove':
> drivers/rtc/rtc-ds3234.c:161: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type
> drivers/rtc/rtc-m41t94.c: In function 'm41t94_remove':
> drivers/rtc/rtc-m41t94.c:139: warning: passing argument 1 of 'platform_get_drvdata' from incompatible pointer type
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Signed-off by: Dennis Aberilla <denzzzhome@yahoo.com>
> Cc: Mark Jackson <mpfj@mimc.co.uk>
> Cc: Kim B. Heino <Kim.Heino@bluegiga.com>
>

Just FYI.
A similar patch "spi/rtc-{ds1390,ds3234,m41t94}: Use spi_get_drvdata()
for SPI devices"
from Geert Uytterhoeven is already merged to linux-next.

Regards,
Axel
