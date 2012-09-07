Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733Ab2IGOiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:38:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43863 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2IGOis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:38:48 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Thread-Topic: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Thread-Index: AQHNSRRxSJBCL2eqoUaZnppvZVbxc5b39csQgAf6AbD//7R+gIAAaf7ngH9m9fD//6SlgIAAXtAHgAABHtA=
Date: Fri, 7 Sep 2012 14:38:42 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA29C22@DBDE01.ent.ti.com>
References: <1339558031.26190.4.camel@phoenix>
 <331ABD5ECB02734CA317220B2BBEABC13E9D83E7@DBDE01.ent.ti.com>
 <CAF+7xWkh6CHvcur2iDs0Nwp_nO8i=6tYyTVauL6qtyrrMctjjA@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13E9D84D9@DBDE01.ent.ti.com>
 <20120618124513.GM3974@opensource.wolfsonmicro.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA29B8E@DBDE01.ent.ti.com>
 <20120907142149.GE4438@opensource.wolfsonmicro.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA29BAA@DBDE01.ent.ti.com>
 <20120907143001.GF4438@opensource.wolfsonmicro.com>
In-Reply-To: <20120907143001.GF4438@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.132.219]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 20:00:59, Mark Brown wrote:
> On Fri, Sep 07, 2012 at 02:26:53PM +0000, AnilKumar, Chimata wrote:
> > On Fri, Sep 07, 2012 at 19:51:51, Mark Brown wrote:
> 
> > > You didn't send a patch.
> 
> > Its there, above to my comment
> > https://lkml.org/lkml/2012/6/18/308
> 
> Right, but my reply was saying we should do something different so I was
> expecting an update which implemented one of the suggestions.

I will send the formal patch.

Thanks
AnilKumar
