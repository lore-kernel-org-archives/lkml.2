Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2ACRaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:30:30 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:45854 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754136Ab2ACRa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:30:26 -0500
Date: Tue, 3 Jan 2012 09:30:20 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Dell Studio 1536 needs pci=nocrs to boot.
Message-ID: <20120103093020.0cbcd735@jbarnes-desktop>
In-Reply-To: <20120101145354.GA1791@elte.hu>
References: <20111230193704.GA2874@redhat.com>
	<20120101145354.GA1791@elte.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jA4ezylLp8Ulm7JM7ek.Yj="; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jA4ezylLp8Ulm7JM7ek.Yj=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Jan 2012 15:53:54 +0100
Ingo Molnar <mingo@elte.hu> wrote:

>=20
> * Dave Jones <davej@redhat.com> wrote:
>=20
> > Some machines don't boot unless passed pci=3Dnocrs.
> > (See https://bugzilla.redhat.com/show_bug.cgi?id=3D770308 for details of
> >   one report. Waiting on dmidecode output for others).
> >=20
> > Currently there is a DMI whitelist, even though the default is on.
> >=20
> > This patch extends that dmi list to add a blacklist to automatically
> > apply disable it when necessary.
> >=20
> > Signed-off-by: Dave Jones <davej@redhat.com>
>=20
> Acked-by: Ingo Molnar <mingo@elte.hu>
>=20
> Jesse, will you take this one?

Yeah, I can take it.  Bjorn, any comment (I'll bounce over the
original)?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/jA4ezylLp8Ulm7JM7ek.Yj=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPAzssAAoJEIEoDkX4Qk9hVNIP/0Ck2o8gRDVR0zZ0AngayE62
rhTug6I11oc+1iLcs8saN2WJab9mFlJNdUU59t8yE1Mi2vH+KBLAykXW/MO6Ofdw
uLWwik/EzB+fiZCL/wpKH18CuSUrXGiLEDadl0hg4oWJBqzWXH+iqg0ttVwX9246
Kytrbbf2SWUykgMOkMbVAMyhFiu/0shIUsgi3eeA4GusNPsnPqI6wcIoMLW1LzXO
i/Zoac003iDR0Lh5AEd3y9YWXUnKYDSfp8gvAjnLq2JwlC/bZOWiayT5AO2Cno1F
KyiuOmtAl7yTkVX+z3r83lfOwi2a0bjGoPTZOiGPmvQ2hfBn5NbrlhZEpQ8EmZ2h
R/08QereDieEzTpMpcD0zkcZaHiumfuv7sYecCXH7TQ4uP3IzVWJWDNdZhf7pwUc
aiBaG0Fd8WoxhJHGje5d8KU+ozl4ljh1HTU6qSb15lcnSCfZLj4ukS2tHtvDFWnM
e2d8TGziZB0LoRVw3zPyowxnOdXThie9FBanL+rPdSmS3ve7e4HWT6V96vz4ouXL
C4ttNGlgyb9i+qKS0h1XCNtycd/mUB93JXZPmhjyyOOvlYfu/s/avfdVpnhtpCGc
udst7fja4azt1V7pThR8e8J82opv7o0wncQXUqv8VVmSNch3b7PWrqfULYOFPmOF
JpCamaQguK+axNVoYq3c
=vExQ
-----END PGP SIGNATURE-----

--Sig_/jA4ezylLp8Ulm7JM7ek.Yj=--
