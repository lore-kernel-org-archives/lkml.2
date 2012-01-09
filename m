Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2AIJTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 04:19:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12768 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2AIJTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 04:19:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Jan 2012 01:19:40 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Mon, 9 Jan 2012 14:49:36 +0530
Subject: RE: [PATCH V1] TPS62360: Add tps62360 regulator driver
Thread-Topic: [PATCH V1] TPS62360: Add tps62360 regulator driver
Thread-Index: AczOq6YNc3FoLqiST0q6LBSMJLBgbgAA8org
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9E2@BGMAIL01.nvidia.com>
References: <20120106185755.GC2893@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0DE@BGMAIL01.nvidia.com>
 <20120107191047.GA3590@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0E4@BGMAIL01.nvidia.com>
 <20120108165819.GB29065@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9A3@BGMAIL01.nvidia.com>
 <20120109071128.GA22134@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9B6@BGMAIL01.nvidia.com>
 <20120109073859.GG22134@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBDABA9D6@BGMAIL01.nvidia.com>
 <20120109084845.GA15277@opensource.wolfsonmicro.com>
In-Reply-To: <20120109084845.GA15277@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Monday, January 09, 2012 2:19 PM, Mark Brown wrote
> > > On Monday, January 09, 2012 1:09 PM, Mark Brown wrote

> > If valid gpios will be passed then driver will use the LRU mechanism
> > for getting desired configuration register for configuring the desired
> > voltage (passed through the regulator_setvoltage())and set the gpios
> > accordingly through gpio libs.
> > In this approach, because we need to set two different gpios for
> > desired logic, the output will not go in proper transition from
> > current to new one, for some time when we completed setting of
> > one gpio and setting second gpio.
> 
> Isn't that an issue anyway?
If device is designed like this then I think this will not be an issue.

I am happy that I understand the design and in sync with you.
I will send the patch with having this change.
Thanks you very much for clearing and helping me on understanding
and design.


