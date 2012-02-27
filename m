Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2B0OI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:08:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51186 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab2B0OI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:08:56 -0500
Date: Mon, 27 Feb 2012 14:08:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC] regulator: Convert ab8500 to use get_voltage_sel()
Message-ID: <20120227140853.GH3191@opensource.wolfsonmicro.com>
References: <1330074945.8642.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wtrm9ATX0sn6fFKv"
Content-Disposition: inline
In-Reply-To: <1330074945.8642.1.camel@phoenix>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wtrm9ATX0sn6fFKv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 24, 2012 at 05:15:45PM +0800, Axel Lin wrote:
> This change is required to make ab8500_regulator_get_voltage_sel work.
> The regulator core will call set_voltage_time_sel only when get_voltage_sel is
> implemented.

Applied, thanks.

--Wtrm9ATX0sn6fFKv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPS45XAAoJEBus8iNuMP3d5lEP/iwDFHA/T7edflopu3diLQsx
3v/3dPsCe/4oSf1i7tszrCLQE5ggS+MJ2EKCwkrbPDt6Gof9rbMBNiwdkPue103S
Bg5kI7j7d6Hk3jDFpG9IHwShgl2xjD1te+znK1BpBBgFF3RRMBmKW7wdMGVJ93K+
7FGEKzP2euUGCRii5erOmMtDO2QiqCqU0ank2E9y3RNT8n9vmARmajTOaJ5g0sFM
HkIunTlbwQfkxxxqI4LDIJ8DANgodVor1WJXEj62m+8d6hTpculQeFsV3pYcRZY8
ef5we092S5UVM8LyLJ2BxUzjBVAhlReo3sDW2Bfu77RKa2ZvunnomVSFRcRR7Tzc
wMAWh5SQ0gljsj/UEp3nLAn6MbiyMYu04Ssa/4BSBtRM3ZIWXSHjLzKg2YHbj7Lc
7ydvDKw1Au6V5bixp5wvVyoYD8hXOgp5ddy6/34ab8c3kfs0MNe8W7U2ADKx/JTr
HuIprFZuP4fQVB4M3Z/9YZwV3uN18JRCC+r0X3CFwC7cT/qBtzZGmZsM2S6YJiBL
+7mRnLZjWrPrWb6Ho0EPrhZA2CK/c75aK+oAfuObMAQ9ddpxFvibj23q0paifBh8
zAXdsLhun9Eys+vDhB69ub2NoxKzPD/dofTN7nbUedRONAqEz6ggvf0EtElm5Dlf
927JLcVo8EpWVhuQoNEc
=bVbf
-----END PGP SIGNATURE-----

--Wtrm9ATX0sn6fFKv--
