Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab2GSMfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:35:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54591 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab2GSMfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:35:42 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH] regulator: tps65217: fix build error if REGULATOR is
 not enabled
Thread-Topic: [PATCH] regulator: tps65217: fix build error if REGULATOR is
 not enabled
Thread-Index: AQHNZLBltySQ8gWfykuGTjdobYDAi5cubl2AgABcyGD//6eFgIABnOoQ
Date: Thu, 19 Jul 2012 12:35:24 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9F98DB@DBDE01.ent.ti.com>
References: <1342593663-23938-1-git-send-email-anilkumar@ti.com>
 <20120718094449.GA22739@opensource.wolfsonmicro.com>
 <331ABD5ECB02734CA317220B2BBEABC13E9F8BD7@DBDE01.ent.ti.com>
 <20120718100013.GC22739@opensource.wolfsonmicro.com>
In-Reply-To: <20120718100013.GC22739@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jul 18, 2012 at 15:30:13, Mark Brown wrote:
> On Wed, Jul 18, 2012 at 09:55:57AM +0000, AnilKumar, Chimata wrote:
> 
> > Regulators platform data is added to platform device in MFD driver, which we
> > need for regulator driver, of_regulator_match() is used to check the regulator
> > consumers if we pass DT data. If we do not enable CONFIG_REGULATOR then
> > of_regulator_match() is not exported, so we see this error.
> 
> Why are you doing that in the MFD driver?
> 

I got your point, I referred tps6586x driver while developing the initial driver.
Based on tps6586x MFD driver I added REGULATOR flag. I think tps6586x MFD driver
need to be cleaned up.

I will submit a patch to make tps65217 MFD driver independent of REGULATOR
framework.

Thanks
AnilKumar