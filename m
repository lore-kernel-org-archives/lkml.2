Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2ABJsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 04:48:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58145 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2ABJss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 04:48:48 -0500
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH 1/2] MFD: TPS65217: Add new mfd device for TPS65217
Thread-Topic: [PATCH 1/2] MFD: TPS65217: Add new mfd device for TPS65217
Thread-Index: AQHMwTK1zssV+wAOUUeoOy+ljcxe7pXo4nEAgAaiSnCACUWCMA==
Date: Mon, 2 Jan 2012 09:48:40 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC103FF03@DBDE01.ent.ti.com>
References: <1324617679-14301-1-git-send-email-anilkumar@ti.com>
 <20111223104918.GD2834@opensource.wolfsonmicro.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.157.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> > 
> > > +/* All register addresses */
> > > +#define TPS65217_REG_CHIPID		0X00
> > 
> > You should verify this as part of the probe() routine - read it back to
> > make sure it's what's expected, and log the chip revision too in case it
> > is useful for diagnostics.
> > 
> 
> Added chip verification code to mfd probe and printing the regulator ID &
> version number.

TPS65217 has two versions A and B.
i.  TPS65217A - not supporting DVFS on AM335X
ii. TPS65217B - supports DVFS on AM335X

Right now I am supporting the version B but not A since I am testing DVFS on
AM335X.

I have BeagleBone with me having TPS65217B, but the CHIPID reads 0x70
(corresponds to TPS65217A)!
I am discussing with hardware folks on what to do about this, but for
now I will skip interpreting the CHIPID. I can print it out for reference
though.

Thanks
AnilKumar
