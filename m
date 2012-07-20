Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2GTKM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 06:12:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56747 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab2GTKMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 06:12:54 -0400
Date: Fri, 20 Jul 2012 11:12:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH 2/6] regulator: add new lp8788 regulator driver
Message-ID: <20120720101252.GU4495@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FD7A3@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A3RWl4qWgABmkY4K"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FD7A3@DQHE02.ent.ti.com>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A3RWl4qWgABmkY4K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 18, 2012 at 02:32:57PM +0000, Kim, Milo wrote:
> TI LP8788 PMU has 4 BUCKS and 22 LDOs.
> The voltage of BUCK1 and BUCK2 can be controlled by external gpios.
> And some LDOs also can be enabled by external gpios.
> The regmap interface is used for regulator operations.

Applied, thanks.

--A3RWl4qWgABmkY4K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQCS8FAAoJEBus8iNuMP3dRlYP/j9TtDZ2VI3NBcVlvWlVkRF/
YgYYHCbC/9bk6+YOBqkLyl8g/2v89j+i0jLxK7EdN7p7PYvBDMDpoCv462hZzUVj
MXnux6vQaot6hKV3ICqQkZTnCFVeFGYI+0euZrMa/hWhHdqCrKH1AJTvpTHfU3rh
66Dg3qoYY5YIBXOSfEiRxpC7KfVN/ijDJ+ESE2rSb5VUTGtgu8rLgn/blk+k8HAs
9ZbCsiz8WDcdAe2dbdUC64ekkYrVu3J097X4uPbJHK/diPX2Mel1IaeI4dn5sh8N
wuUq1kEj+4niFzWLbFELt0PX2W212OOaoY22pQo8ohJq3mzKyiVCMkRzSoLA34QU
4kc9aST7+A0e8u9OUV2Cltv3jMfsezAaVhEd0pobMCG0qZ6ttG07+Nuu5hNQZeg6
YbJTS/xgErRGl4M3co4XVRPOwzzVPKziXIHcUVHBX9xW4DsmmDtw/9mZQ2q2gfeq
ScBhIC3phrnmmbQxpW4aEWyKFzcvhWiOsYpOsERqbFVRnQu86uIhA+FvdaQ00wEa
BdVHShs6hwuXfq+oyRHM5OVB9NruFDQmczy/pYbPIgCYXWNvuupcVqRNmBFjVtsZ
b6V6dTWeCgxuFReCZnRZaEbb6uOaAwErAuTJTZFqfEXR76Gd2XCF908hhqFZeNh0
I39B/RVZAcQL6hPUN/xp
=2ymo
-----END PGP SIGNATURE-----

--A3RWl4qWgABmkY4K--
