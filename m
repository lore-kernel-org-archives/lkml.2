Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2FQTwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 15:52:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38539 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab2FQTwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 15:52:05 -0400
Date: Sun, 17 Jun 2012 20:52:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 1/2] regulator: wm8350: Use wm8350_ldo_list_voltage
 instead of open code to verify selected voltage
Message-ID: <20120617195203.GH4267@opensource.wolfsonmicro.com>
References: <1339502910.2881.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHbokkKX1kTiQeDC"
Content-Disposition: inline
In-Reply-To: <1339502910.2881.1.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHbokkKX1kTiQeDC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 12, 2012 at 08:08:30PM +0800, Axel Lin wrote:
> Call wm8350_ldo_list_voltage() instead of open code to verify selected voltage
> falls within specified range.
> Use wm8350_ldo_list_voltage() here is less error prone.

Applied, thanks.

--xHbokkKX1kTiQeDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3jVdAAoJEBus8iNuMP3d2acP/1dTxP9XLE3fbkFCPY4qe6hk
+Nta+jMNZdCw6bRwZu2Nn00tE03OJ1KS5ViXWzOQF2JUpDqBXr/HrRgNbvCRIhuH
Mp1aBxZboE/tMiaIu66P99Sf8wb9kBiO91lfvQCL5CFOBdw4hMPd523rrTcPbgsa
JrlnRY5NCzkj9x7VNxV5qj0ef5dNVRmX9Le7hkfLWVL4xnBtbS3Cy4druWd2M0rH
fhE6cHcUB79Kef4CEO6o1AIiwrdVIcqg+sToOUMx37c2s3SFQjmSsx08+hpBaKHw
m2/o3yZeOPk3XP9SDvIuDSOhwLYy97mNo5EzbbTa52ceRTPvYJ9otL/coVr5mLWF
UDx7rvVUioZhGeNucEY19LDi0Zh7nRlcOXf4CuD3SQnqGhfcL0MMwfbDevcl1WvE
JE3nzMMFWSgZGyfe3LR7/Glg7qQiDiKgVnop8+62scgmsCFUa8dqAWdGLUPmlFys
6LXWiRc4MAj0Hn7xxkKTy0owcTYjF6eGeS7UEu8vxF37yCbbc5jmTAmeXFuftUD4
p1UgVu3qN4oKlT/V7NLjSW3h1FJvKGfFzH6LE82axMDs23fz4XqtY6uFba71pl67
Wq+1c64fXomyJ3EqCNbInKH0RC2jRBQInSw13qcXpd3uF5YqXYicaPTXvT0Y5fME
wqoiiBXOslvpKAs14245
=KqUm
-----END PGP SIGNATURE-----

--xHbokkKX1kTiQeDC--
