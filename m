Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2BWUB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:01:26 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:46602 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756178Ab2BWUBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:01:25 -0500
Date: Thu, 23 Feb 2012 12:01:19 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: RFC: export constants from shpc.h?
Message-ID: <20120223120119.782db1da@jbarnes-desktop>
In-Reply-To: <20120223195053.GB28779@redhat.com>
References: <20120216145447.GA25979@redhat.com>
	<20120223085004.17e32327@jbarnes-desktop>
	<20120223195053.GB28779@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GVoBx32FN151sNORELLM3pX"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GVoBx32FN151sNORELLM3pX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Feb 2012 21:50:54 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Thu, Feb 23, 2012 at 08:50:04AM -0800, Jesse Barnes wrote:
> > On Thu, 16 Feb 2012 16:54:49 +0200
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >=20
> > > I've implemented an shpc controller emulator
> > > in qemu, so I needed a bunch of constants
> > > similar to what drivers/pci/hotplug/shpc.h has.
> > >=20
> > > Any objections to adding a PCI_SHPC_XXXX prefix
> > > so these and moving them to pci_regs.h?
> > > PCI utilities can then use them from /usr/include/linux.
> > >=20
> > > One can see how a utility that looks at slot LED and MRL
> > > states might be useful
> > > (we'd need to export the base offset through sysfs
> > > to make it possible to use such in parallel with shpc).
> >=20
> > pci_regs.h is generally reserved for architected regs,
> > but maybe a
> > separate header file makes sense.  Or just patch libpciaccess or
> > pci-utils with your tool.
> >=20
> > --=20
> > Jesse Barnes, Intel Open Source Technology Center
>=20
> Fair enough, but out of curiosity,
> could you pls clarify what is meant by 'architected'?
> SHPC is a PCI-SIG spec after all, not a vecor-specific interface...

Sorry that's what I meant; I was thinking it was one of the vendor
ones.  Putting the SHPC reg definitions in pci_regs.h is fine.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/GVoBx32FN151sNORELLM3pX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRpsPAAoJEIEoDkX4Qk9hCAgP/A+Ugm/4cJJOty0EHtpcxnRS
kM/jk87ctWGhoQz4WtCvGiu9sZXUXsJG00Vd+6hjUiw0mOSLtyaXpJgR52dphRCM
/f2KfQ1flKTBpP70iqBzhDkxsYEvLQvlWcVRg5E91AULuJg7+AIOIP4zOAzrW1Sl
riyYUcGbALG+ht0lMKiZNGCfBQhhYZjvbvG6gO0JixddW07DZ0uNyOydrcUgzmS+
7WwLhZgsjrvfTnY22n7qXr6Q9JtIxuZeZsvhbIDwIMM3UVKXE/DObrrfJo3oXZuc
SyETnVCHzN+J/t2iTTuz2gJeIriYYYdLA9cNU/GIhooRBeTlLizIoiiB/diLXUkk
boLg9pGxeuO9JAipK+q9BO4LSLN+Q+PrtcsodttsYpplMs5PF8zSt72IQ1OG5ZD6
g1iqRY0mz68GqUT4plqfBo+eVQaao8yuGkE5ds4uQ8kYuRHvzX1aGcvPKv5qqq5C
PQhTD8944qKC+FurjwUMoZrkx/lLHqjDHWe7UhAcqXbmiPgG84bwWbxVLBkS+ddq
vQfW7aHsCZ7J4dqmjJc0Gg2qufc5Q8fRabB2A6OtvKxTlRO7NOJPd1KYpqR+BEv8
JqfRO//u73X6NX9Sr3YegDYLH97AXDWTrOLI4MHKm0VjvoPtICfP9GufvGyDeXyZ
lLSeh6eabPn1OSQDGYli
=uEXb
-----END PGP SIGNATURE-----

--Sig_/GVoBx32FN151sNORELLM3pX--
