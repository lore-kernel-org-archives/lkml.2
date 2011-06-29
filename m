Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab1F2QuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:50:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48934 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818Ab1F2QuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:50:03 -0400
Date: Thu, 30 Jun 2011 02:49:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 29
Message-Id: <20110630024953.de9c84af.sfr@canb.auug.org.au>
In-Reply-To: <20110629141806.GB16986@kroah.com>
References: <20110629162454.e2326fcf.sfr@canb.auug.org.au>
	<20110629141806.GB16986@kroah.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Jun_2011_02_49_53_+1000_hbgx0X3SVzl_yiO3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jun_2011_02_49_53_+1000_hbgx0X3SVzl_yiO3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 29 Jun 2011 07:18:06 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Wed, Jun 29, 2011 at 04:24:54PM +1000, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Changes since 20110628:
> >=20
> > My fixes tree is empty again (the early part of mmotm-2011-06-22-13-05 =
is
> > mostly now included in Linus' tree and the experiment failed anyway :-))
>=20
> Did it fail?  I thought it at least solved the build errors that people
> were seeing in the staging tree in other arches, allowing them to move
> on to other, "real" issues that they had.

The experiment was the start of getting parts of Andrew's tree into
linux-next - the fix patches were a side effect (they are now in Linus'
tree).  Hopefully, the experiment will continue in another fashion soon.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Jun_2011_02_49_53_+1000_hbgx0X3SVzl_yiO3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC1exAAoJEDMEi1NhKgbsSZMIAIes0sFCkQmcIWZdsqWBWfD1
psC31/xl9kYZxITukVFkctRF2Rh1II618LM1MYKby8/UddXnQiHyRdeVSwZdCWiH
QrelgW8LO+2F3mEBwpKzBBw6V/HhRpN0ErGt3vhpYWGMQVofvd42jFflUb7WNdiR
SUibBlTsQKE7CIxkwb/znEqTgbTPLFUy8HP12gh30w+vqJdd/IXCPIgkrVvqXq94
/GXWdJK7PvYDmEEV4OWumkd88037tWxVT+/byaU/kVMDjk2RomXdZjyDLc2wB24r
ddLzxqTUMcJvLdT7PdWm4coLa3gkUqiqOVsuGpqFp7Wx0jiw5LTaoWAHzR6uH4A=
=yi3S
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jun_2011_02_49_53_+1000_hbgx0X3SVzl_yiO3--
