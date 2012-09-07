Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab2IGObM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:31:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43920 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482Ab2IGObH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:31:07 -0400
Date: Fri, 7 Sep 2012 22:30:59 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Message-ID: <20120907143001.GF4438@opensource.wolfsonmicro.com>
References: <1339558031.26190.4.camel@phoenix>
 <331ABD5ECB02734CA317220B2BBEABC13E9D83E7@DBDE01.ent.ti.com>
 <CAF+7xWkh6CHvcur2iDs0Nwp_nO8i=6tYyTVauL6qtyrrMctjjA@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13E9D84D9@DBDE01.ent.ti.com>
 <20120618124513.GM3974@opensource.wolfsonmicro.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA29B8E@DBDE01.ent.ti.com>
 <20120907142149.GE4438@opensource.wolfsonmicro.com>
 <331ABD5ECB02734CA317220B2BBEABC13EA29BAA@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13EA29BAA@DBDE01.ent.ti.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 02:26:53PM +0000, AnilKumar, Chimata wrote:
> On Fri, Sep 07, 2012 at 19:51:51, Mark Brown wrote:

> > You didn't send a patch.

> Its there, above to my comment
> https://lkml.org/lkml/2012/6/18/308

Right, but my reply was saying we should do something different so I was
expecting an update which implemented one of the suggestions.
