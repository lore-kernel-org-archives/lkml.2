Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab2COCI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 22:08:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40095 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab2COCIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 22:08:55 -0400
Date: Thu, 15 Mar 2012 13:08:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, Michael Walle <michael@walle.cc>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (arm-soc tree related)
Message-Id: <20120315130849.9274a279aed2b10eb90d5c2f@canb.auug.org.au>
In-Reply-To: <20120315002020.GA16189@titan.lakedaemon.net>
References: <20120315105901.7b10c9f4de9374a613436988@canb.auug.org.au>
	<20120315002020.GA16189@titan.lakedaemon.net>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_13_08_49_+1100_l4E9qFC9srUYHKDl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_13_08_49_+1100_l4E9qFC9srUYHKDl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 14 Mar 2012 20:20:20 -0400 Jason Cooper <jason@lakedaemon.net> wrot=
e:
>
> On Thu, Mar 15, 2012 at 10:59:01AM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the final tree, today's linux-next build (powerpc
> > allmodconfig) failed like this:
> >=20
> > drivers/ata/sata_mv.c:4185:1: error: '__mod_of_device_table' aliased to=
 undefined symbol 'mvsdio_dt_ids'
> >=20
> > Caused by commit f1e1e148c5cb ("ARM: kirkwood: sata_mv: add device tree
> > binding").
>=20
> That's my mistake.  I did a pull request for the wrong branch.  Olof,
> could you please drop the offending branch and I'll submit a new pull
> request once I have a chance to test Arnd's irq patch?

I will revert that commit today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__15_Mar_2012_13_08_49_+1100_l4E9qFC9srUYHKDl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYU8xAAoJEECxmPOUX5FEeKcP/jRgpuaCbUGZL6RYn5wqBUoB
VbtUuMp17D3vfU9vpI7mZQU+m21kTTEj9zEViROJMAcALR2aMackctfQpOpKqOIE
UhJdWsFqVlQw54O1k556OJFOcTUNFKUBIpb0vdiW3kVlnGSqX9G4aelLzaFr2YQp
Ip4jTyL3PfzkkflBbPooxBWItykY6WNqwSL20CpVx7yJ11wcDYHFkkq38RJEUdfo
ZO1LbxiIMi6yPEwuziIayECYeBCy4Zy93O77OZ5iVRc0ik/SHxZfZSigud47ISn6
yDfTy8BIKQTipSxSc86QIfHqk1Srzhfp3l+GWA7N89Toeh9ImOgABWykgBqiV3Ku
JFK32eiafFpkv4u5Z8w6ua27TfhKA04e1eQgeKzX8RJyT0vTgc6K59rC5weV924+
V0cRE6TfsLLcAUqHtRbFS4LqdwtG92pZdF48RoOwEdAF8c4s9JMcCvkS/M7o5SLS
FWyyJqX9ApSd/PKWBue0oG0k2SUF6yo2PbowE1FrAkbt7mRXBXjjdQDaC8VlSwr8
lSQTHVPkMxYkJG04qBQIzHXWrMMOB6fksroKjWonpKLKOCyBDOBNgpKlTY95q6+s
mL6kaU7nmysADCdd2U5MTt92w3blACOReEBWRn8IdzPsaZtqYzeDu8HTDtLT8R9V
qa60GzJogu2qc9fL/UJi
=5bRR
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_13_08_49_+1100_l4E9qFC9srUYHKDl--
