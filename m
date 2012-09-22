Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab2IVBSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 21:18:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35446 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2IVBRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 21:17:43 -0400
Date: Sat, 22 Sep 2012 11:17:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konstantin Ryabitsev <mricon@kernel.org>, linux-kernel@vger.kernel.org,
        backports@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Helping with backports: linux-next, linux, linux-stable - a few
 enhancements
Message-Id: <20120922111733.75b2bfd0c2397a98635c1f1b@canb.auug.org.au>
In-Reply-To: <CAB=NE6WQg8PvuKc0kphSQWjuAhc+tRd8MEd+51tCwU3AfHwzjQ@mail.gmail.com>
References: <CAB=NE6UVZ2HQU27LdkzUFe3of6N1v8YZYVMKsfA+0Wmg5nRBug@mail.gmail.com>
	<20120921081614.GA17547@kroah.com>
	<CAB=NE6WQg8PvuKc0kphSQWjuAhc+tRd8MEd+51tCwU3AfHwzjQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__22_Sep_2012_11_17_33_+1000_E08/N/_vZPavgtMq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__22_Sep_2012_11_17_33_+1000_E08/N/_vZPavgtMq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Luis,

On Fri, 21 Sep 2012 09:24:44 -0700 "Luis R. Rodriguez" <mcgrof@do-not-panic=
.com> wrote:
>
> > I don't see how pulling linux-stable into linux-next really helps anyone
> > out, linux-stable is so far behind what is in linux-next it's not funny.
>=20
> By pulling linux-stable into linux-next you get to be able to run
> things like this from within linux-next:
>=20
> git format-patch --grep=3D"stable@vger.kernel.org" -o
> $PENDING_STABLE_DIR v3.5.4.. $MY_FILES
>=20
> That is, from v3.5.4 up to that day's linux-next tag.
>=20
> Without linux-stable linux-next does not get the v3.5.4 tags to allow
> me / users of compat-drivers to do this. We do this to accelerate the
> incorporation of stable pending-stable patches into a release based on
> a stable extraversion release.

You need to have linux-stable as a remote in your tree then.
linux-stable and linux-next are independent tree and will never share any
commits that are not in Linus' tree as well.  I do not need more commits
and tags in my tree than I already have.

> Right, absolutely! Using a remote arrangements fixes this completely
> for me. I alone can live happy doing what I do but since I have users
> depending on using compat-drivers to make their own set of releases
> and test things it means I have to get folks using compat-drivers to
> also set up the same git remotes arrangements. That's fine but I'm
> looking to simplify it if I can for users.

If they fetch from your tree, and your tree has Linus' tree and
linux-next and linux-stable in it (and you have local tracking branches
for those trees, or they explicitly use --tags when they fetch) then they
will get all that from you.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__22_Sep_2012_11_17_33_+1000_E08/N/_vZPavgtMq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQXRGtAAoJEECxmPOUX5FEs5MQAJNzXIrt2eTKIpCGml1kkg4K
Q0x9SXD7kiDOR0VAE2uaenLRk5RGHYoi+AcWpG/zml8HCLvcZsRFWxBLEukuRD8s
3OpMZr0+fC6kxUfIULTV57+WBecE8Abz4vWjvsWPSJLUcRlnFBYaPTlb9ls2skzB
7+HyG4I9W9qqqV3GfrhRBls5kCdbEQrvc5K6pPocK/bRaN0u9wuLPT11DLU5v+K4
EflYqY3aprGS5EHd0Fh4dPlD77yzFJ0VC/60sXfhMXaUisFfD69ocp7xzbLgKlTR
BBfBTKmjUK+ouj3+qqEq/yNm5GLUiheFVzldWgyihBHfuAQPdHVfLuP1Ttprk2/0
64nILhM0z+2mZDmV7kDonZQzvl3785QA0PvIwRN+zpJR09qoRnaNUkjPo9LIwocr
Zq4hYKa7CCt8Pf2KNWtkWeAPifapoPbFOIwRjWxx1C2PM0LE2YVTiAUfGxwweNe4
cOAjCp3JZPQnx9TCKOwLc0yVv4moiUjQfYduGrMyl8skUwPrW+hjWKYJrLxJr29S
6MD20U9KTtdcFkALTX6lT5JhgpcVPiQef7vUVIMZcX6lCp3/KfD9MMn9GQx3zAiR
t9tl3h8E1HmGOjYIzXBebl7vmPdzt/kehLWUXMJHZZepERzkMy5adHBwKL9fteAH
RFmbBpP+Jg98FR5RnuZs
=Tvwd
-----END PGP SIGNATURE-----

--Signature=_Sat__22_Sep_2012_11_17_33_+1000_E08/N/_vZPavgtMq--
