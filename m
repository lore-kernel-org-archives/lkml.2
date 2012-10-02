Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2JBPWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:22:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53326 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2JBPWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:22:01 -0400
Date: Wed, 3 Oct 2012 01:21:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <JBeulich@suse.com>
Subject: Re: [PATCH] xen/Makefile: resolve merge conflict with 9fa5780beea1
Message-Id: <20121003012159.029e5282fa108697eaa3a9ff@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.02.1210021606000.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1210021606000.29232@kaball.uk.xensource.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Oct_2012_01_21_59_+1000_pG.fPmj3ziZxjhp2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Oct_2012_01_21_59_+1000_pG.fPmj3ziZxjhp2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2 Oct 2012 16:13:15 +0100 Stefano Stabellini <stefano.stabellini@eu=
.citrix.com> wrote:
>
> This patch is actually a merge conflict resolution between Konrad's Xen
> tree and the following commit:
>=20
> commit 9fa5780beea1274d498a224822397100022da7d4
> Author: Jan Beulich <JBeulich@suse.com>
> Date:   Tue Sep 18 12:23:02 2012 +0100
>=20
>     USB EHCI/Xen: propagate controller reset information to hypervisor
>=20
>=20
> Compile dbgp.o only if CONFIG_USB is defined.
> After all xen_dbgp_op relies on hcd_to_bus.
>=20
> This patch should be applied on top of=20
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D134919011231980&w=3D2
>=20
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

I'll use this resolution if it is needed tomorrow.  Assuming that the
other build problem with the xen-two tree is fixed, of course.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Oct_2012_01_21_59_+1000_pG.fPmj3ziZxjhp2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQawaXAAoJEECxmPOUX5FEmCwP/i1qnJV8Gg636RBjQL1DnKEG
wS3xy+qoZjcYA8yyxg2fIv5xinO7BCcrIcTiYHRNCr4/O38O8dPk9Fi5/t39jTHt
D5DK5P8T6i5Q6WdmEzHN/YFgnOpYx+UC8jsmA4zq18+qhhQtqhGomHEFqsKjXblL
k7DjmBuRrrptWA7VbJADFMKcmXTEjbuiJPyIsVZNQ6pSXh/FuC3iDV7U41tSRBd2
gzb9thERjBPKdkXPk8ERYdwR36FuQloooBk6tXe/0utxPHnEf4sTRctlVtVPIKqT
xNWD3hlWR1KmDapjzMgBDS3vYxS+golkaPEZ83kdIuWriCs1jfI0jAR+m0V6/F6U
YcWe75i5nrIVIK6bJHx8TltiHmHIvShz7NHyrAtK0HaKUIZjTyCYOX3CEfw3zXc/
ijDffBeiidnsfHTZistc16f+BBacBrZf0SdGfAnfiJ0Tq2HE38warwlbP9cpQt9Q
h1F1KmsQEWmxQyjWCA8QDZh+4XMKblVSmUhqby4YofHCeUn4N466CvXUXDUaogSU
EFtB0SaUuZTcW8Z2/UFAqn8Z/mTv40zW4Ruj9gs/0YUuQvYXp1CrA5pk2FVK7jge
9sbzhk9If45X5D4KIl6NmBotXEdX6f4FnUHva0nSVCgWPTDVZznaPsOzskYWfw0a
2lPfFVSiqeOfzLgnPo51
=dG5J
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Oct_2012_01_21_59_+1000_pG.fPmj3ziZxjhp2--
