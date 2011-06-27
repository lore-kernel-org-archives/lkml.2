Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab1F0DIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 23:08:00 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:33879 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab1F0DG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 23:06:27 -0400
From: Baohua Song <Baohua.Song@csr.com>
To: daoguang wu <wdgvip@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wdgvip@gamil.com" <wdgvip@gamil.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] INPUT:Add ABS_PRESSURE input event support for
	touchscreen driver
Thread-Topic: [PATCH] INPUT:Add ABS_PRESSURE input event support for
	touchscreen driver
Thread-Index: AQHMMmw+q7Lm5r8fFUK635sRs78/TZTP9RmAgACUE1A=
Date: Mon, 27 Jun 2011 03:05:32 +0000
Message-ID: <5EB3BFCD089AD643B9BB63439F5FD5E937BB882D@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1308881738-6392-1-git-send-email-wdgvip@gmail.com>
	<20110624124154.GC19804@sirena.org.uk>
 <BANLkTi=O44wyaFB_B83LGiQhAVtFOp64pyhMaCKCf_YZz6b1GA@mail.gmail.com>
In-Reply-To: <BANLkTi=O44wyaFB_B83LGiQhAVtFOp64pyhMaCKCf_YZz6b1GA@mail.gmail.com>
Accept-Language: zh-CN, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.125.4.86]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5R39vtD012212



> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org
> [mailto:linux-arm-kernel-bounces@lists.infradead.org] On Behalf Of daoguang
> wu
> Sent: 2011Äê6ÔÂ27ÈÕ 10:15
> To: Mark Brown
> Cc: kgene.kim@samsung.com; ben-linux@fluff.org;
> dmitry.torokhov@gmail.com; linux-kernel@vger.kernel.org;
> wdgvip@gamil.com; linux-input@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] INPUT:Add ABS_PRESSURE input event support for
> touchscreen driver
> 
> 2011/6/24 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> > On Fri, Jun 24, 2011 at 10:15:38AM +0800, Wu DaoGuang wrote:
> >> The touchscreen driver s3c2410_ts.c doesn't work well when using
> >> the tslib, an abstraction layer for touchscreen panel events.
> >> Tslib needs ABS_X ABS_Y and ABS_PRESSURE events to report, but only
> >> the former two the driver can provide.
> >
> > It seems much more sane to fix this in tslib, the kernel is not actually
> > reporting pressure meaningfully here and there's already BTN_TOUCH to
> > report if the pen is down.
> >
> yeah,I will try to fix it in tslib.

You may send a patch to tslib. 

> Thanks a lot.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> 
>  To report this email as spam click
> https://www.mailcontrol.com/sr/wQw0zmjPoHdJTZGyOCrrhg==
> t4zoc+!n!INSV2C4qhUHSr1YUlPAL0C6yBmfTIRMbBnxawg== .


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
