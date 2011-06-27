Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab1F0I7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 04:59:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38353 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab1F0I5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 04:57:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l63JfKjg6/oShW+hg5+9+khoN+yz7DCWl4n/OEBHEL088Km8dSpIAhuPdPYODxzaNq
         RIGHgf+P+309e+NafhhfVoWt+EGxi9geeLIQ0S2ToIciJ3D1BdEZzaJTAvBQpyTpBWdq
         h+xyYxW/y68fJUqTfahicb9dQ//ybMMcXH23s=
MIME-Version: 1.0
In-Reply-To: <a8885a55-bf77-43d7-8491-045137aa38ee@email.android.com>
References: <1308881738-6392-1-git-send-email-wdgvip@gmail.com>
	<20110624124154.GC19804@sirena.org.uk>
	<BANLkTi=O44wyaFB_B83LGiQhAVtFOp64pyhMaCKCf_YZz6b1GA@mail.gmail.com>
	<5EB3BFCD089AD643B9BB63439F5FD5E937BB882D@SHAASIEXM01.ASIA.ROOT.PRI>
	<a8885a55-bf77-43d7-8491-045137aa38ee@email.android.com>
Date: Mon, 27 Jun 2011 16:57:48 +0800
Message-ID: <BANLkTi=wU04jiOE-5GDDG9Pd4PgVnN61bTkqGfnkShHKo7iVFg@mail.gmail.com>
Subject: Re: [PATCH] INPUT:Add ABS_PRESSURE input event support for
 touchscreen driver
From: daoguang wu <wdgvip@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Baohua Song <Baohua.Song@csr.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wdgvip@gamil.com" <wdgvip@gamil.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/27 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
>
>
> Baohua Song <Baohua.Song@csr.com> wrote:
>
>>
>>
>>> -----Original Message-----
>>> From: linux-arm-kernel-bounces@lists.infradead.org
>>> [mailto:linux-arm-kernel-bounces@lists.infradead.org] On Behalf Of
>>daoguang
>>> wu
>>> Sent: 2011Äê6ÔÂ27ÈÕ 10:15
>>> To: Mark Brown
>>> Cc: kgene.kim@samsung.com; ben-linux@fluff.org;
>>> dmitry.torokhov@gmail.com; linux-kernel@vger.kernel.org;
>>> wdgvip@gamil.com; linux-input@vger.kernel.org;
>>> linux-arm-kernel@lists.infradead.org
>>> Subject: Re: [PATCH] INPUT:Add ABS_PRESSURE input event support for
>>> touchscreen driver
>>>
>>> 2011/6/24 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>>> > On Fri, Jun 24, 2011 at 10:15:38AM +0800, Wu DaoGuang wrote:
>>> >> The touchscreen driver s3c2410_ts.c doesn't work well when using
>>> >> the tslib, an abstraction layer for touchscreen panel events.
>>> >> Tslib needs ABS_X ABS_Y and ABS_PRESSURE events to report, but
>>only
>>> >> the former two the driver can provide.
>>> >
>>> > It seems much more sane to fix this in tslib, the kernel is not
>>actually
>>> > reporting pressure meaningfully here and there's already BTN_TOUCH
>>to
>>> > report if the pen is down.
>>> >
>>> yeah,I will try to fix it in tslib.
>>
>>You may send a patch to tslib.
>>
>
> This has already been fixed in tslib a couple years ago. I'm not sure if a
> new version was cut or not.
> --
> Dmitry

I try the latest tslib ,and find there is no such problem and the
latest version of tslib  can be downloaded from
git://github.com/kergoth/tslib.git.

Thanks a lot.
