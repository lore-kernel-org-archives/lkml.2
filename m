Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493Ab2DLIeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:34:20 -0400
Received: from masquerade.micron.com ([137.201.242.130]:52280 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab2DLIeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:34:15 -0400
From: "Luca Porzio (lporzio)" <lporzio@micron.com>
To: Arnd Bergmann <arnd@arndb.de>, Minchan Kim <minchan@kernel.org>
CC: =?utf-8?B?7KCV7Zqo7KeE?= <syr.jeong@samsung.com>,
        "'Alex Lemberg'" <Alex.Lemberg@sandisk.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "'Rik van Riel'" <riel@redhat.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "'Yejin Moon'" <yejin.moon@samsung.com>,
        "'Hugh Dickins'" <hughd@google.com>,
        "'Yaniv Iarovici'" <Yaniv.Iarovici@sandisk.com>,
        "cpgs@samsung.com" <cpgs@samsung.com>
Subject: RE: swap on eMMC and other flash
Thread-Topic: swap on eMMC and other flash
Thread-Index: AQHNDpzybzWjK4z/iEWbFOApOu/42JaDDSoAgAGt6QCAApJvAIAAMT0AgAADxACACVvKAIAAz84AgABafICAAAlnAIAAUMEAgADL1gCAAH2/gIABVeiA
Date: Thu, 12 Apr 2012 08:32:57 +0000
Message-ID: <26E7A31274623843B0E8CF86148BFE326FB5AEE2@NTXAVZMBX04.azit.micron.com>
References: <201203301744.16762.arnd@arndb.de>
 <201204091300.34304.arnd@arndb.de> <4F838870.9030407@kernel.org>
 <201204100840.11763.arnd@arndb.de>
In-Reply-To: <201204100840.11763.arnd@arndb.de>
Accept-Language: it-IT, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.5.103.1]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.500.1024-18812.005
X-TM-AS-Result: No--19.031500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3C8YUYR008425

Hi All,

> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-owner@vger.kernel.org]
> On Behalf Of Arnd Bergmann
> Sent: Tuesday, April 10, 2012 1:40 AM
> To: Minchan Kim
> Cc: ì •íš¨ì§„; 'Alex Lemberg'; linaro-kernel@lists.linaro.org; 'Rik van Riel';
> linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org; Luca Porzio
> (lporzio); linux-mm@kvack.org; kernel-team@android.com; 'Yejin Moon'; 'Hugh
> Dickins'; 'Yaniv Iarovici'; cpgs@samsung.com
> Subject: Re: swap on eMMC and other flash
> 
> On Tuesday 10 April 2012, Minchan Kim wrote:
> > I think it's not good approach.
> > How long does it take to know such parameters?
> > I guess it's not short so that mkfs/mkswap would be very long
> > dramatically. If needed, let's maintain it as another tool.
> 
> I haven't come up with a way that is both fast and reliable.
> A very fast method is to time short read requests across potential
> erase block boundaries and see which ones are faster than others,
> this works on about 3 out of 4 devices.
> 
> For the other devices, I currently use a fairly manual process that
> times a lot of write requests and can take a long time.
> 
> > If storage vendors break such fields, it doesn't work well on linux
> > which is very popular on mobile world today and user will not use such
> > vendor devices and company will be gone. Let's give such pressure to
> > them and make vendor keep in promise.
> 
> This could work for eMMC, yes.
> 

I like it ;)

> The SD card standard makes it impossible to write the correct value for
> most devices, it only supports power-of-two values up to 4MB for SDHC,
> and larger values (I believe 8, 12, 16, 24, ... 64) for SDXC, but a lot
> of SDHC cards nowadays use 1.5, 3, 6 or 8 MB erase blocks.
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
