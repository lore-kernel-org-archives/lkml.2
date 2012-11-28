Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab2K1TUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:20:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38034 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883Ab2K1TU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:20:29 -0500
Date: Wed, 28 Nov 2012 19:20:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT RESEND] regulator: pcf50633: Use linear_min_sel and
 regulator_[map|list]_voltage_linear
Message-ID: <20121128192027.GC32691@opensource.wolfsonmicro.com>
References: <1354070464.13461.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="56p9wBiXEyg+KhLM"
Content-Disposition: inline
In-Reply-To: <1354070464.13461.1.camel@phoenix>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--56p9wBiXEyg+KhLM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 28, 2012 at 10:41:04AM +0800, Axel Lin wrote:
> This driver can be converted to use linear_min_sel and
> regulator_[map|list]_voltage_linear.

Applied, thanks.

--56p9wBiXEyg+KhLM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtmP0AAoJELSic+t+oim9HwkP/0p7LGXoJIymcIW6bdmLMGnw
FG/lpZtcw6uFbhCJzTq0kIbGx9dtXR3YAYwaz7/CQOmyWr/eY5xbvUNyAbpP2gmQ
AAqM/9z+aCEjQ0DnSR9Qlic04cpvZNTYvgMcORwXi36hijjXX8e4RYWcQPxA61v8
C9X+fsSgpMIW8WpFiUTnt5aTnaCfYZV+TGBPNIniVPF0G/0aHkNcBM2pUOX3qU3D
J9O7L0soJcBFwv63WFy/BuSi097qx5AsOv09cE+TvkYxt42g4VYIZM34uDNHtWk9
VZJgzsLQ7D7IkShkr2U8y1rJYApDw0UzmRJg/0OzZfedQZFtp/TtdySk5ACJzM3t
jVg+DEZ1cdnx8i4rypiZZ8gUQVzhFLBcVfRViiR3C7y8+B091D42ot0Oscmml+cq
6O6xB+mMXOdkkfbQveogQCK5wr/MTeEQNTZf8mMluRVgLSyoSxEG/ky0hECRzHdQ
UVqsr9mR+Ref7R1Wo/8Lq1o5RzBPugah0Bey3IJBK+Gmq2mg6ghHxZnUnGzLlxcP
KXc5egtXkQ9w1pyFpfjjtwbpcTKuAjELzxYqd6KKo2JbGdfVqbhSveDnDG1QMkG+
wsff2cG7XelH6DYNM4+ppH5fJeLD3YR8Xk+0t/FKQC6D3jummF+u5JBAut+xMP8D
gPpY1FBDmjeUllv5yAZW
=KwpD
-----END PGP SIGNATURE-----

--56p9wBiXEyg+KhLM--
