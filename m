Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab2CHDvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 22:51:55 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58345 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab2CHDvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 22:51:54 -0500
Date: Thu, 8 Mar 2012 14:51:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>
Subject: Re: linux-next: manual merge of the powerpc tree with the arm tree
Message-Id: <20120308145131.fad50bbc79c36f0b0b12d101@canb.auug.org.au>
In-Reply-To: <25744.1331174036@neuling.org>
References: <20120308120422.e071cba36425eacbee1f8d98@canb.auug.org.au>
	<25744.1331174036@neuling.org>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_14_51_31_+1100_qb3nrSWB2o1L7.Z="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_14_51_31_+1100_qb3nrSWB2o1L7.Z=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mikey,

On Thu, 08 Mar 2012 13:33:56 +1100 Michael Neuling <mikey@neuling.org> wrot=
e:
>
> Surely we only need SPARSE_IRQ now and not MAY_HAVE_SPARSE_IRQ. =20
>=20
> In fact, keeping MAY_HAVE_SPARSE_IRQ seems to make SPARSE_IRQ user
> selectable, which we don't want anymore since ad5b7f1350c2.

Yes, indeed. I will fix up the merge resolution for tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Mar_2012_14_51_31_+1100_qb3nrSWB2o1L7.Z=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWCzDAAoJEECxmPOUX5FER+oP/26BkUtVgGjB9+/Oqv737c0x
6MzRh+6SpOoQe7E6SsBKIBMCL57FUqZIRZ2ATnZ4d0PllPiobcZgSJB/4GTpOc9y
gLAA1lWrtrpeWhZqQLegmQ7fDz7jRjiAaIkXPiVuAtib0QFK7POK0r4mrUbdeHKx
i0wYQn6xfQ7bN1c3gGTkpFZuwmf+zbOcGYPM6IcsCOAX3tb56w3oPbDyw9x9C8rf
rFgAzMDKOq+6ey8SKnIixGRzeNASDVWhkguFAA6CRD89OMKshRpvfBfLWngQu8HW
BIIEoWmlSRjNtQsWPI0cQyBW7yp9Q04FmsBeReJdYp2+uZNx61tKWW/vvy3Nli/9
yv6w3ngc6Wc0Tw+56fOHmnSPjHTe5aQsUkTND7co1fZ7YdCdo2E9L7/49zk2FG35
d1qYiAAw5p3i54W9OoK2hSn6P9XZ52yhFmNrr3GGSb0+xCKINTitpPx7vr8UPepi
BE2Q7E6O3pLeO9NI58iF4nM6KG3laJv4DupfBJWUVtC2NJCsYOW5io5Vwe6b7vG0
WDzCBFtp92tK+r6rIkkQ1mu1+JyVZv79lTysaDgL3fp56CdIyOHhomagWZRvL2cv
DlLX5jr3WCLaVTkwBxdZ6yKLxzvvFEBNa99TT5gH1e6wFGag33VQuTiwz7JTbx1z
82gEp+Zy9fiNpkBHgAsC
=etEQ
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_14_51_31_+1100_qb3nrSWB2o1L7.Z=--
