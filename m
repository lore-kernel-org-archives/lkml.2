Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1JLFaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 01:30:25 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:38763 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1JLFaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 01:30:24 -0400
Date: Wed, 12 Oct 2011 16:30:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: linux-next: manual merge of the staging tree with the pm tree
Message-Id: <20111012163022.1d7a57974a8bdf86f8aee051@canb.auug.org.au>
In-Reply-To: <20111012162805.1056a7f7fe3f1140d767a601@canb.auug.org.au>
References: <20111012162805.1056a7f7fe3f1140d767a601@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Oct_2011_16_30_22_+1100_cfsdwJLsM6xc.7=9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Oct_2011_16_30_22_+1100_cfsdwJLsM6xc.7=9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 12 Oct 2011 16:28:05 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the staging tree got a conflict in
> drivers/Kconfig between commit a3c98b8b2ede ("PM: Introduce devfreq:
> generic DVFS framework with device-specific OPPs") from the pm tree and
> commit 46a971913611 ("Staging: hv: move hyperv code out of staging
> directory") from the staging tree.
>=20
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Also drivers/Makefile.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/Makefile
index 97c957b,ef693cf..0000000
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@@ -127,5 -127,5 +127,6 @@@ obj-$(CONFIG_IOMMU_SUPPORT)	+=3D iommu
 =20
  # Virtualization drivers
  obj-$(CONFIG_VIRT_DRIVERS)	+=3D virt/
+ obj-$(CONFIG_HYPERV)		+=3D hv/
 =20
 +obj-$(CONFIG_PM_DEVFREQ)	+=3D devfreq/

--Signature=_Wed__12_Oct_2011_16_30_22_+1100_cfsdwJLsM6xc.7=9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlSXuAAoJEECxmPOUX5FE50UP/j7BAthslv3rfzea4oWJzxfQ
RErpqcHgSOjId758aRLzzmKDsPuiwdFX1b3DJD2i3/LfCTcNJzWOJIFITbREh4Sm
DauLb1Pn9hqait7o76fuaUM4rpoqKY95Doz+Bc6XCOveuuol5+7DMPqc4iClyFa9
f6svyK6S83u2iTxlnX1o5teVn5OGvzfUvxuVBGR+vdC5bXk+krP34xr9AVQ5xbfW
SSjO8SpCJKOh4nur/FnWkI3DKTavtJS7WHm3MkwJtjbBFDTx86SjGgtdryC0wEKN
y3EeNBDhF2vbt/VEpMXq+AFpPC+0mLZKjeUlPtkszx5i3z/0R5YWgdKSs09QP29R
RTugEbkxHMQCoqUMxTSQBLxKGz+Nh1+PK1NaxiyK3HpUFSZRKq2eZdvSEve1sSU2
IVkvexOF5YDwCmq0lbTBIZS6JYUqhOVxKHrikASYj7kHvchp/5lrQoR1FE+7xH8X
N+NIGehvkzotG1Bij1jre12RIYegSHxseF2HmCA21B+EBE174gbSh6Qx43IFBX2Y
tvrNChGMuiicSs9ThkBmEhRo2tQpDyfm2wSHaD8NZqGCdQ+j9bri3JVqUkxfVtLr
dV0yyxCWZ0Pe14R+F2U7PeCUEw4zFqK5uAAwHSMan1rXIlr87fiDmtjuP/OMv+yk
zZ4zhnhe7d2+wPLnqj0A
=Bzbx
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Oct_2011_16_30_22_+1100_cfsdwJLsM6xc.7=9--
