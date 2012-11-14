Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2KNGZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:25:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59624 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2KNGZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:25:22 -0500
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RESEND] regulator: tps65910: fix BUG_ON() shown with
 vrtc regulator
Thread-Topic: [PATCH RESEND] regulator: tps65910: fix BUG_ON() shown with
 vrtc regulator
Thread-Index: AQHNwiyLzW1RQJhikESt5UCAv6KHzJfof2MAgABc2ZA=
Date: Wed, 14 Nov 2012 06:25:15 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA6B07A@DBDE01.ent.ti.com>
References: <1352872479-25462-1-git-send-email-anilkumar@ti.com>
 <20121114061913.GB7407@opensource.wolfsonmicro.com>
In-Reply-To: <20121114061913.GB7407@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 11:49:14, Mark Brown wrote:
> On Wed, Nov 14, 2012 at 11:24:39AM +0530, AnilKumar Ch wrote:
> > Fix BUG_ON() error if tps65910 VRTC regulator is used with out
> > rdev->desc->volt_table data. Recent changes in regulator core driver
> > which add support for "regulator_list_voltage_table" have BUG_ON() if
> > regulator descriptor do not have voltage table information. This patch
> > adds the voltage table information to fix the issue.
> 
> This is already applied...  got dropped from -next for a day for some
> reason but it's there.  When resending please do say why.
> 

Hi Mark,

Sorry for the noise (My bad missed the version change details). I have
checked in regulator/for-next tree and not found, so resend the patch
thanks for you time.

Thanks
AnilKumar
