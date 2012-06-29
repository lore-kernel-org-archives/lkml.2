Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab2F2HJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 03:09:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33164 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616Ab2F2HJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 03:09:42 -0400
Date: Fri, 29 Jun 2012 08:09:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Kumar <vipin.kumar@st.com>,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20120629070939.GO28922@opensource.wolfsonmicro.com>
References: <20120629133811.31f56e9778b856f59d77ecd6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ctUzwJm0i+kwMBIK"
Content-Disposition: inline
In-Reply-To: <20120629133811.31f56e9778b856f59d77ecd6@canb.auug.org.au>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ctUzwJm0i+kwMBIK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 29, 2012 at 01:38:11PM +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Already fixed before you sent this.

--ctUzwJm0i+kwMBIK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP7VSoAAoJEBus8iNuMP3dmFIP/1uNFIudQh+Zn3YwOmjKwAGL
mrEOFM4IdIimB6a40bvIOHScxHQRocrsivLjU0wwewQvbpzrlWrWf2/JOEM0g2dw
tY57ZjWnvMPADh1zyAeDckTUmehzBU4KxBJuavhTPunCRBilySEIWxQTOoKzGY5P
JfVdPAV7oJo9lEikNEcVNxrKCmaVQ92r58kGdIwFvUqdM5kszPG64OnUeiSKSvWZ
hck4AKzxmmzincSd07LzT6jVGaSsGw6BoMuWpNUbRTjoUniycKv5stFKFDJTxW+0
qrL26F5zRQgaaFtaHkRlSgHYAol5iCAzvaTFfh3ZTfDd8O7sn5+wZBdQ6c+10t/0
Tn7rj5gcPy09bSgcmWVk8UtO6dXHXH+S5qu0skwyR7ATG++8gXPrNUoyHdmt5ZYm
+kjx3QPFe4VkhRgUiA84O9+opibLYr6F0NtsOJC9ECTCcqmEY21INoE+bvgfSPb0
WZBBrQkwJICJEdrotDomLCNlJun/P3ncA1oVZ6LLZEbtasnq+8VWkDsS4FqNXWNM
PrbtnYBswSeuIKO8lLKcVo0ADBEDfjyGEkmDyahQlTR3gjMgdwrj2KQkQg3UvH7w
Pw+625vQEpLx1qY8eedMssmhk4lXVoY09HEhWkUtjPwiWD/RDjqJq44QSF8Xxx+O
I9YXHAvn91iGsVZkyEiF
=jTgK
-----END PGP SIGNATURE-----

--ctUzwJm0i+kwMBIK--
