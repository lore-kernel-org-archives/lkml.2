Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab2FUJYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:24:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49521 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932465Ab2FUJYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:24:11 -0400
Date: Thu, 21 Jun 2012 10:24:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: Re: [PATCH 3/3] regulator: change message level on probing lp872x
 driver
Message-ID: <20120621092408.GK4037@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FC05A@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZQs1kEQY307C4ut"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FC05A@DQHE02.ent.ti.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZQs1kEQY307C4ut
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 21, 2012 at 08:03:56AM +0000, Kim, Milo wrote:
> Use err log rather than warning message when the platform data is NULL

Really what you should be doing here is making the driver able to probe
without platform data at all, there should be no need for it.

--YZQs1kEQY307C4ut
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4ueHAAoJEBus8iNuMP3dHCEP/iQ1GYHqM+GijZG5gML9Iwwz
YbBHMF38GyHOcZ6cyyQVrIoMSi4EP9zIZp+zZYeE8VfDXq74o1GKf4yOP5lCNUrO
sIkMIUZk6WZktL4nClfD9iphtbtvnki2O7/Q0uTAx0Lxh4D90GnBQ0WUQAcbYqLG
FfawrnqEism0HXQ1yXttRY3rT8u3Qs28NS4P0FsMuHVYsa+0V95tY2R7CE98MMsj
jlbJY1aKLgVGMWKVA9soeEp+w3Gqp660Z5+wWSpmzqD9qIDqnQMwhNQC8Bl2W25m
z7LpNbG3oC7T4AOuuDPskflcCD4X93rNXvXNvLlA5Moo3YZvTnJ7yexV5Rc/MaRn
edDAwQLb5gA/PsnhXtN0ntEZJnohjLob5/PuMCW3jDs2s3t4B3Ptx8YzgWeVdhXx
hiInvB4RiIrl+M3ayjNfxWFEhwXjZ3XlkKzvj45RsyNaNjxTprteFZLEohQIrDym
QXY7bYpEPwaK5bIDyEulXrV3uU4FREOg3iuqUFC/JnxZ78uvlfvb5I8LGweNJPJc
5cPk5QvCW7UXyQfMXHin/ppKFUf4nPKtey2EOcyDa3b/P621y3JX/3T+T+tjiMl4
vWxCnOB3epYHVwMk9vZq4kaLUkPaVZZnyjjQqPXLhLSfGaYD6nbsbaevL7ETh6UW
ncUBN4MR3mzbEPL3NkBk
=pn3d
-----END PGP SIGNATURE-----

--YZQs1kEQY307C4ut--
