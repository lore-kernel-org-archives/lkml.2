Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2ASDY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 22:24:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17522 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2ASDY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 22:24:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Jan 2012 19:24:25 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 19 Jan 2012 08:54:19 +0530
Subject: RE: [PATCH V1 2/2] regulator: tps65910: Initialize n_voltages for
 rails.
Thread-Topic: [PATCH V1 2/2] regulator: tps65910: Initialize n_voltages for
 rails.
Thread-Index: AczWCnwKyehglP3MQPOC9LRbF3oFuQATuvRw
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DC3DCC1C3@BGMAIL01.nvidia.com>
References: <1326899836-14470-1-git-send-email-ldewangan@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAAE10@HQMAIL01.nvidia.com>
 <20120118175613.GT8732@opensource.wolfsonmicro.com>
In-Reply-To: <20120118175613.GT8732@opensource.wolfsonmicro.com>
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

> On Wednesday, January 18, 2012 11:26 PM, Mark Brown wrote:
> 
> > > +		.table_len = 73,
> > >  	},
> 
> > Forgive me if these comments are bogus since I'm not familiar with
> > regulators much, but:
> 
> > a) Don't you want to use ARRAY_SIZE() instead of hard-coding table_len's
> > value?
> 
> > b) Don't you need to set .table to actually point at the table too? If not,
> > isn't tps65910_list_voltage() going to dereference a NULL pointer, since
> > it will dereference .table if .table_len is set?
> 
> It's not actually a table at all any more as the driver calculates the
> values, table_len is misnamed and should be renamed as well as set.


Do you want to rename the variable in this patch or in separate patch?
In place of table_len, I will say n_voltages as this is most common name
in regulator world.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
