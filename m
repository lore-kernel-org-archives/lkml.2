Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2GDPln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:41:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54158 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366Ab2GDPlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:41:40 -0400
Date: Wed, 4 Jul 2012 16:41:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, rob@landley.net, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        swarren@nvidia.com
Subject: Re: [PATCH V2] regulator: fixed: dt: support for input supply
Message-ID: <20120704154137.GF4111@opensource.wolfsonmicro.com>
References: <1341414333-6359-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KMIs29sPfC/9Gbii"
Content-Disposition: inline
In-Reply-To: <1341414333-6359-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KMIs29sPfC/9Gbii
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 04, 2012 at 08:35:33PM +0530, Laxman Dewangan wrote:

> that the supply name should be passed through desc->supply_name
> in both DT and non-DT case.
> Making the change to have this.

>  .../bindings/regulator/fixed-regulator.txt         |    2 ++
>  drivers/regulator/fixed.c                          |   15 +++++++++++++--

The supply name would need to be passed in via platform data, we should
never end up with both the init data and descriptor setting the supply
name.

--KMIs29sPfC/9Gbii
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9GQQAAoJEBus8iNuMP3dwjEQAIT4zrs3vh+nbYsgJ3+hGWT6
sa9iR16uyJZg4obIRxG+l9fRVsC+ZA5qLuR9X9Q9MNTjIYoM5qIFy5ywiAI6I6rl
j8MFQ1tooPq8unzWmDIPWut7KwQmH0I9EX5cvQ6Ib1zB57ueulrpzw4Wv//fQ5EV
a9bnfRlZpApg4SSUTLsjwioaQOr4ZMdq3jA3/I2m1puhBv4/uFe6R810M1c3C9wM
JvcPfCXU8CoBJ6bRykULOAUgGCo0jgwpHg25/Pkh4L1+nLGmA5ZXkaONUEB2CtMv
HBVk8KR2EAESlSBOA039buVlOk0rwSBawbK+e78oUuJAzAtN0tPwgI3QTB2Tq1EI
Ixkcn0R+hJbMbQ/A76TheeMTAjgxZ6k1moNRHmfiHBKoC0tO8TtHlb1fNmM/rDOi
CX3cvMwaPksHdN6GT8wHl3WJY1+FcLaSN0i+M2e9O5BfPX3DlDB9FuGCP4D7NQg2
N1cs0VqDXRzgzU9XzG4bBuQXN+u3MQsj209Xp8x1KIGgxgTsVZ77Ledk4eLszYVK
I4oRL9k683E8BIpIQgsLmXcQfeVCcHaAC3tyqhSwKzIbN4RWQCZm/H8zuv2b1k0N
yRkdfjneQeRrw8TGBxDoHXBK2TRUGJ5CES3JubiBUczqGxX8gDNOt9fVfCBOihV0
iGBz5qgBDE4GMCJLibiM
=v3j7
-----END PGP SIGNATURE-----

--KMIs29sPfC/9Gbii--
