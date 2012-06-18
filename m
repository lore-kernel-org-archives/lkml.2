Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab2FRMPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:15:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56506 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2FRMPG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:15:06 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: "axel.lin@gmail.com" <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Thread-Topic: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Thread-Index: AQHNSRRxSJBCL2eqoUaZnppvZVbxc5b39csQgAf6AbD//7R+gIAAAawAgAABMQCAAFyB0A==
Date: Mon, 18 Jun 2012 12:14:58 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9D8476@DBDE01.ent.ti.com>
References: <1339558031.26190.4.camel@phoenix>
 <331ABD5ECB02734CA317220B2BBEABC13E9D83E7@DBDE01.ent.ti.com>
 <CAF+7xWkh6CHvcur2iDs0Nwp_nO8i=6tYyTVauL6qtyrrMctjjA@mail.gmail.com>
 <20120618120158.GJ3974@opensource.wolfsonmicro.com>
 <CAF+7xWkdpGFLg5Dwj4sLp9ttocOFbREwLAEpd9MJ-ChDeJcenA@mail.gmail.com>
In-Reply-To: <CAF+7xWkdpGFLg5Dwj4sLp9ttocOFbREwLAEpd9MJ-ChDeJcenA@mail.gmail.com>
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

Hi Axel,

On Mon, Jun 18, 2012 at 17:36:14, Axel Lin wrote:
> 2012/6/18 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> > On Mon, Jun 18, 2012 at 07:55:59PM +0800, Axel Lin wrote:
> >
> >> Since this patch is target for 3.6, this is not required.
> >> The regulator core will set it automatically.
> >
> > Do we need to fix it for 3.5?
> No. In current Linus' tree, this driver does not use
> regulator_[is_enabled|get_voltage_sel]_regmap.
> 

Yes, I understood. This fix is not required in 3.5.

If we use *_voltage_sel_regmap APIs then this regmap pointer is required
otherwise not required because regulator APIs passing proper regmap pointers.

Thanks for your clarification.

Regards
AnilKumar
