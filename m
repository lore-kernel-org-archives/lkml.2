Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1HBBXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:23:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36817 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab1HBBXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:23:44 -0400
Date: Tue, 2 Aug 2011 11:23:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Mason <mason@myri.com>, Jordan Hargrave <jordan_hargrave@dell.com>
Subject: Re: linux-next: build failure after merge of the pci-current tree
Message-Id: <20110802112336.fd2d2b577a2a71892189733b@canb.auug.org.au>
In-Reply-To: <20110802104838.ac7f46b54e8a3fcc4cdd9448@canb.auug.org.au>
References: <20110802104838.ac7f46b54e8a3fcc4cdd9448@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Aug_2011_11_23_36_+1000__iiwE3T7ah_0Mc4z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Aug_2011_11_23_36_+1000__iiwE3T7ah_0Mc4z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

On Tue, 2 Aug 2011 10:48:38 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the pci-current tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> ERROR: ".pcie_bus_configure_settings" [drivers/pci/hotplug/pci_hotplug.ko=
] undefined!
>=20
> Caused by commit b03e7495a862 ("PCI: Set PCI-E Max Payload Size on
> fabric").  Missing EXPORT_SYMBOL?
>=20
> I have used the pci-current tree from next-20110801 for today.

And the same for the pci tree (which is identical today).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Aug_2011_11_23_36_+1000__iiwE3T7ah_0Mc4z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJON1GYAAoJEDMEi1NhKgbsfU0H/jczxFd5cqA4KGNDrD1z3ZMJ
NL8UZcKvi0reEp3ObmOcXckPhr5tJGtghuN1HlWlBLr9bQQSRySYdFCjJijdYiar
wLltOljEjyZi2qTP7aGQ2SPlvyA7RDON/vapiSqYo8tVkpCtVDROkDba+OU3qxpH
fHOTRHT0dJaThgmLNVqma0fvOk8U82iHNk5Q9gVDOn7V8tpukgDg+xIFayviEFOz
Zk3/i87N2erqelmPRK5C1DSHRBPP+eeUSRuaWckzlFLMfdFMbz2+pscIxA3GloMz
2Gn4foF+et9fJ7710fQ7+FG0WEBb6zO/eDMfBM/6Fy/fO3eogQDAeVQQIIaWttc=
=73Is
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Aug_2011_11_23_36_+1000__iiwE3T7ah_0Mc4z--
