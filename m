Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab2EWKTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:19:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33400 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755559Ab2EWKTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:19:34 -0400
Date: Wed, 23 May 2012 11:19:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nancy Chen <Nancy.Chen@freescale.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: anatop: Use correct __devexit_p annotation
Message-ID: <20120523101931.GJ4085@opensource.wolfsonmicro.com>
References: <1337735288.24555.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCKy2vjPBX+S/5dE"
Content-Disposition: inline
In-Reply-To: <1337735288.24555.1.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCKy2vjPBX+S/5dE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2012 at 09:08:08AM +0800, Axel Lin wrote:
> __devexit functions are discarded when CONFIG_HOTPLUG
> is not set, so the symbol needs to be referenced carefully.

Applied, thanks.

--FCKy2vjPBX+S/5dE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvLmoAAoJEBus8iNuMP3dVW8P/0qQ1uNsOIOgbzi1xzAeG+9Z
yXaMWLAR+LszntZ72hzlJlLd+E6XwYrePC+43R4ZntB7wOX1k2YwT+xPZaQ8pZgj
V+PKT2a/LSsTm9Ld/AUhJdidq5Lagw+PH0bkMKMFU+J2h4lRyyU/DEOUN7LGoUEQ
SXWNxiSZhMcW9oDrNQE6rnh7AD6hlXA9lAF8LjS+KyIpADn9NrAsbZRm9ytT1pvJ
qYo/fIkkjkxS9zrt4URQihU9/lMoErvL90f7GRSKRT6QubjK7UE7LMAzxcoDoJoy
aMVJXSepfB1ZFdI5qxSFsqtzXcdtnLuHKaVQdw2W/zUk/a0vrKzvQ+BQAhrw1NLL
LXgNSyLYFaFgekinL2PJSrHX4qYw06EoBntA8twcHufy1m7a6mb/p/RZZp4AO+Oc
I1k35RsraRt/zmD56WpsoQRgW/dh5dV1iq9BgwBBjb6Aph093PS3686u+yhi8KgI
/nOwom+/TGWSd7hGfqIlrEtz1DkbAz1BJi6ZVuCBnEkXABgbfhumAjtQj6NX1i7b
HnJEBhKsJ15ah3ESafMJdCIhKqR4MoT4HV2n+QNhc3pozCjYCk0WzplzWDKG+GCr
Q1ze/R1CX4nGsaZk90lRmGmcgQ2i8rxoTMNwwClD6K3WNdYisn18eNxmdWBE3ZF3
ADGK2haSP35YB3VnnXS5
=Pp9Q
-----END PGP SIGNATURE-----

--FCKy2vjPBX+S/5dE--
