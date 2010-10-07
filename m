Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab0JGWkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:40:49 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16843 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0JGWks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:40:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Thu, 07 Oct 2010 15:40:42 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Greg KH <greg@kroah.com>
CC: "jic23@cam.ac.uk" <jic23@cam.ac.uk>, "joe@perches.com" <joe@perches.com>,
        Andrew Chew <AChew@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Thu, 7 Oct 2010 15:39:02 -0700
Subject: RE: [PATCH v5] staging: iio: light: Adding driver for ISL29018 ALS
Thread-Topic: [PATCH v5] staging: iio: light: Adding driver for ISL29018 ALS
Thread-Index: ActmaLZmxEQsvjDyTYmFHId/bYeyEAAAMayQ
Message-ID: <E88A1D35AF5437468E5B14C7C4BA61C702D37C9E9C@HQMAIL01.nvidia.com>
References: <1286480883-25589-1-git-send-email-rklein@nvidia.com>
 <20101007214137.GA9269@kroah.com>
In-Reply-To: <20101007214137.GA9269@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o97Mf3Jm000340

Sorry resending new patch (compiles fine for me).

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, October 07, 2010 2:42 PM
> To: Rhyland Klein
> Cc: jic23@cam.ac.uk; joe@perches.com; Andrew Chew; olof@lixom.net; linux-
> i2c@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> iio@vger.kernel.org; Laxman Dewangan
> Subject: Re: [PATCH v5] staging: iio: light: Adding driver for ISL29018 ALS
> 
> On Thu, Oct 07, 2010 at 12:48:03PM -0700, rklein@nvidia.com wrote:
> > From: Rhyland Klein <rklein@nvidia.com>
> >
> > adding support for the ISL 29018 ambient light and proximity sensor.
> >
> > Addressed comments from reviews by Jonathan Cameron and Joe Perches
> >   * Removed some excess dbg prints that only printed function name
> >   * Renamed some properties to make them more descriptive
> >   * Added a property to list available adc resolutions
> >   * Defined arrays for resolutions/ranges as static const
> >   * Change loops initialization to memset for extensibility.
> >     * used sizeof() instead of ARRAY_SIZE() to be safer
> >   * Added a property to list available adc ranges
> >
> > Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> > Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> Too bad no one actually compiled this driver:
>   CC [M]  drivers/staging/iio/light/isl29018.o
> drivers/staging/iio/light/isl29018.c:420:8: error:
> â€˜show_prox_infrared_suppressionâ€™ undeclared here (not in a function)
> drivers/staging/iio/light/isl29018.c:433:1: error:
> â€˜iio_dev_attr_range_availableâ€™ undeclared here (not in a function)
> drivers/staging/iio/light/isl29018.c:435:1: error:
> â€˜iio_dev_attr_adc_resolution_availableâ€™ undeclared here (not in a function)
> drivers/staging/iio/light/isl29018.c: In function â€˜isl29018_chip_initâ€™:
> drivers/staging/iio/light/isl29018.c:451:6: warning: unused variable â€˜iâ€™
> drivers/staging/iio/light/isl29018.c: At top level:
> drivers/staging/iio/light/isl29018.c:350:16: warning:
> â€˜show_prox_infrared_supressionâ€™ defined but not used
> drivers/staging/iio/light/isl29018.c:416:1: warning:
> â€˜iio_const_attr_range_availableâ€™ defined but not used
> drivers/staging/iio/light/isl29018.c:417:1: warning:
> â€˜iio_const_attr_adc_resolution_availableâ€™ defined but not used
> make[2]: *** [drivers/staging/iio/light/isl29018.o] Error 1
> make[1]: *** [drivers/staging/iio/light] Error 2
> make: *** [_module_drivers/staging/iio] Error 2
> 
> Please fix this up before resending it.
> 
> thanks,
> 
> greg k-h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
