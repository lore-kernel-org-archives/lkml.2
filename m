Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab2DBPEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:04:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41920 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656Ab2DBPEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:04:31 -0400
Date: Mon, 2 Apr 2012 16:04:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rhyland Klein <rklein@nvidia.com>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20120402150428.GC15197@opensource.wolfsonmicro.com>
References: <20120402113424.3e5981bd914d68a2fb8fcead@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline
In-Reply-To: <20120402113424.3e5981bd914d68a2fb8fcead@canb.auug.org.au>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 02, 2012 at 11:34:24AM +1000, Stephen Rothwell wrote:

> Caused by commit 9dd90c5db040 ("ASoC: max98095: add jack detection").
> At least build test, please.

Should be fixed now.  My build tests are currently broken in mainline
by some perf issues (which I reported with a patch).  I should really
update to sidestep these issues.

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeb/UAAoJEBus8iNuMP3dhcUP/2HYXwKU9uYhbmGnhf8TX+q/
Xa3bfN8n1iS5MqkvyiK11+2gNcJMqCoG1aSSYla4njFgNXaTK6KUDaWLP+IP0GaH
3gKZP61k0XMEp3wk8wANTfP0bKNmVohY+xR0eswsOQA4mBnrBKAAX4KpcP9VATP1
csU3I+2p0QHulTQtKfqPoKUTMTpaSxiX7/FIruiPWatoA7lA3D6g0RDMCzWsyBgv
a7W1VjnEw0dUUOHF9Kk01LbrIhEDmhfgWB+2MKcdUaUXBtgl5a42r1SjDKk0yoQs
GGMBQfcTjwcLgCAfS9Lxv6h85e3Q0t1RPZ5vCkFRsnKgA2wwJlcz1id2qR+kKbvI
rvM2i2E5cZL8RQdfBDS8ZSHd0xSIxSgxJ7eqM4gy2z1tkmAPRfzzIyZR+52RBJqu
p5nbE4gKCnZsHsWRzmrl7nZ9VBRNE8jU9linQteF3LNL7eojZEC3OGqmdii5TEuZ
vG3oSY7bAxlsO4oPxr8/IRT2rzj1z6A8PcVQkns6Phln9sRI0ZsQBt7ASpmKj6Fa
Zc+i4odB6LMaaNbbBTKVsc85+nEk6T5vIiOKDKV5+PSsYrJaUUqPK7Q5ziilbv7N
U8hUN43se0QcN/3YNPoPC+r4jdP/mNDazEHRQNsjYQvdcnW5ZhQ0zoIJhitCbba+
85cpCeKTVmuKq5JXi1eR
=s4mP
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
