Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab1F0CQF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 22:16:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56332 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab1F0CPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 22:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bWBSo86ZEqk4Sz6V+drRbgQPKEsE4u9rAoF9Oc7eqQRsYODP6myH++TCSkjIcDcRCN
         40ikSr3kl5Nwzj2v2jWy0SIXmNijf0hx5GLQ8JeMAX2YE4iLN7C28k5W2J78NTFB6NVP
         YTbDhmu6uV3bHUD2MftzTbWpcLHqHpEmTJKWM=
MIME-Version: 1.0
In-Reply-To: <20110624124154.GC19804@sirena.org.uk>
References: <1308881738-6392-1-git-send-email-wdgvip@gmail.com>
	<20110624124154.GC19804@sirena.org.uk>
Date: Mon, 27 Jun 2011 10:15:05 +0800
Message-ID: <BANLkTi=O44wyaFB_B83LGiQhAVtFOp64pyhMaCKCf_YZz6b1GA@mail.gmail.com>
Subject: Re: [PATCH] INPUT:Add ABS_PRESSURE input event support for
 touchscreen driver
From: daoguang wu <wdgvip@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: ben-linux@fluff.org, kgene.kim@samsung.com, dmitry.torokhov@gmail.com,
        wdgvip@gamil.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/24 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Jun 24, 2011 at 10:15:38AM +0800, Wu DaoGuang wrote:
>> The touchscreen driver s3c2410_ts.c doesn't work well when using
>> the tslib, an abstraction layer for touchscreen panel events.
>> Tslib needs ABS_X ABS_Y and ABS_PRESSURE events to report, but only
>> the former two the driver can provide.
>
> It seems much more sane to fix this in tslib, the kernel is not actually
> reporting pressure meaningfully here and there's already BTN_TOUCH to
> report if the pen is down.
>
yeah,I will try to fix it in tslib.
Thanks a lot.
