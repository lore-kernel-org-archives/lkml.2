Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab0G3EDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 00:03:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49034 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab0G3EDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 00:03:36 -0400
Date: Fri, 30 Jul 2010 14:03:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Erik Gilling'" <konkers@android.com>,
        "'Colin Cross'" <ccross@android.com>,
        "'Olof Johansson'" <olof@lixom.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Changhwan Youn'" <chaos.youn@samsung.com>
Subject: Re: linux-next: manual merge of the tegra tree with the s5p tree
Message-Id: <20100730140331.04c60f73.sfr@canb.auug.org.au>
In-Reply-To: <015801cb2f8a$9bca9b90$d35fd2b0$%kim@samsung.com>
References: <20100730105834.d7ac047f.sfr@canb.auug.org.au>
	<015801cb2f8a$9bca9b90$d35fd2b0$%kim@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Jul_2010_14_03_31_+1000_nxCMXc1MDbujn7/M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Jul_2010_14_03_31_+1000_nxCMXc1MDbujn7/M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 30 Jul 2010 10:57:41 +0900 Kukjin Kim <kgene.kim@samsung.com> wrote:
>
> If there is some conflicts, how can/should I do for it...
> Stephen, please let me know.

In this case, do nothing :-)  The conflicts will get fixed up when either
Russell or Linus merges your tree into theirs.  My email was more of a
"heads up" to let you know that there is some conflict.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Jul_2010_14_03_31_+1000_nxCMXc1MDbujn7/M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMUk8TAAoJEDMEi1NhKgbsjxYH/j2XOyb04TJDWEYkhGCYYHPg
nTLTvvhBW7zeweGuE1fS7M0FEl0/tPDt8aMqJA1pEUttghl9puiwVR5mB38Cf4ID
jAcvTmyur/SCMF0vjrsQdyrrxRpjKILiKcnKHKRrq8T46/KuumfxudWp1xGV/Tqe
hAMYSu7PprQOVB881FltUSWvQMYeqa3EwfuABmxTOsrTFt4SlSann2JnDErE3C5I
VUt0YplQMVmCc7OH1j4jNSkycz/fdwRHLvg4QSeiZ3RpZJUuI+t1bPTfMdH7KswI
VR7q2H+z4EAHHhzhK/9O4v5KGvn3mBIx5hR4TRfU5mze7nagYn/MNuX0QM63c6U=
=TCMY
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Jul_2010_14_03_31_+1000_nxCMXc1MDbujn7/M--
