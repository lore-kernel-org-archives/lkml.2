Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab0GFIvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:51:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33472 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab0GFIvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:51:37 -0400
Date: Tue, 6 Jul 2010 18:51:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: linux-next: manual merge of the usb tree with the v4l-dvb tree
Message-Id: <20100706185132.7dd72993.sfr@canb.auug.org.au>
In-Reply-To: <201007061018.21674.laurent.pinchart@ideasonboard.com>
References: <20100706175332.952fec90.sfr@canb.auug.org.au>
	<201007061018.21674.laurent.pinchart@ideasonboard.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_Jul_2010_18_51_32_+1000_vn9kYuvFovc0uO3+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Jul_2010_18_51_32_+1000_vn9kYuvFovc0uO3+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On Tue, 6 Jul 2010 10:18:20 +0200 Laurent Pinchart <laurent.pinchart@ideaso=
nboard.com> wrote:
>
> > diff --cc include/linux/usb/video.h
> > index 2d5b7fc,429c91a..0000000
> > --- a/include/linux/usb/video.h
> > +++ b/include/linux/usb/video.h
> > @@@ -160,12 -160,402 +160,409 @@@
>=20
> [snip]
>=20
> >  +/* 4.1.2. Control Capabilities */
> >  +#define UVC_CONTROL_CAP_GET                           (1 << 0)
> >  +#define UVC_CONTROL_CAP_SET                           (1 << 1)
> >  +#define UVC_CONTROL_CAP_DISABLED                      (1 << 2)
> >  +#define UVC_CONTROL_CAP_AUTOUPDATE                    (1 << 3)
> >  +#define UVC_CONTROL_CAP_ASYNCHRONOUS                  (1 << 4)
> >  +
>=20
> Can you move those to the first part of the header file, with the other=20
> constants ?

Sure, I just put it there because of the section numbering in the
comments.  This, of course, will not influence how the file looks after
Linus merges it - unless the conflict is fixed up by one of the
maintainers before Linus gets it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Jul_2010_18_51_32_+1000_vn9kYuvFovc0uO3+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMMu6UAAoJEDMEi1NhKgbsdy8H/RANeo3MuJ+r1STvY8GVfHjz
6RENd6wf83wZ1Jk/OTIWezaE2mXMvGj7luJKixGg76OrY9FiDqK92JGlswQj+jTc
FRv6sZX+uqoPyd6esTIInCN7g6K2Gyle+oK8YJ9ULSLy2j0GnPwWWhGHrMK2H/aA
G8NVPKWrbfgedOmJWZcFFeoasg4JJ5SvYblskr5O3jFm7fwK2QrgZf+nI7SAJ4fb
UziSMLeVj7L56EuGJeJLXHtO1JRzI1e3lim7aaYU2SFURpq3gKJLUzL+Vm7eKh5C
ekLXk0BJOXm+4+a0M2hnyzapy952BEykPcb731WyciSx97oeuF0RlHNx0tCcI/I=
=nspR
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Jul_2010_18_51_32_+1000_vn9kYuvFovc0uO3+--
