Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab2FRMGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:06:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51909 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2FRMGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:06:35 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120618120158.GJ3974@opensource.wolfsonmicro.com>
References: <1339558031.26190.4.camel@phoenix> <331ABD5ECB02734CA317220B2BBEABC13E9D83E7@DBDE01.ent.ti.com>
 <CAF+7xWkh6CHvcur2iDs0Nwp_nO8i=6tYyTVauL6qtyrrMctjjA@mail.gmail.com> <20120618120158.GJ3974@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 18 Jun 2012 20:06:14 +0800
Message-ID: <CAF+7xWkdpGFLg5Dwj4sLp9ttocOFbREwLAEpd9MJ-ChDeJcenA@mail.gmail.com>
Subject: Re: [PATCH RFT] regulator: tps65217: Convert to regulator_[is_enabled|get_voltage_sel]_regmap
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/18 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Mon, Jun 18, 2012 at 07:55:59PM +0800, Axel Lin wrote:
>
>> Since this patch is target for 3.6, this is not required.
>> The regulator core will set it automatically.
>
> Do we need to fix it for 3.5?
No. In current Linus' tree, this driver does not use
regulator_[is_enabled|get_voltage_sel]_regmap.

Regards,
Axel
