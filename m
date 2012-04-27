Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104Ab2D0SUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:20:00 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:59644 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761094Ab2D0ST5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:19:57 -0400
Date: Fri, 27 Apr 2012 21:18:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Rajendra Nayak <rnayak@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: constify parent name arrays in macros
Message-ID: <20120427181833.GA24587@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1335529693-14280-1-git-send-email-rnayak@ti.com>
 <CAJOA=zNzkOvzdFSuSzC015ELZWE+Jtj=H5P9fbQSHW3HZdsZow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <CAJOA=zNzkOvzdFSuSzC015ELZWE+Jtj=H5P9fbQSHW3HZdsZow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 27, 2012 at 10:55:50AM -0700, Turquette, Mike wrote:
> On Fri, Apr 27, 2012 at 5:28 AM, Rajendra Nayak <rnayak@ti.com> wrote:
> > parent name array is now expected to be const char *, make
> > the relevent changes in the clk macros which define
> > default clock types.
> >
> > Signed-off-by: Rajendra Nayak <rnayak@ti.com>
>=20
> Good catch Rajendra.  I'll pull it into clk-next.
>=20
> Regards,
> Mike
>=20
> > ---
> > =A0include/linux/clk-private.h | =A0 =A06 +++---
> > =A01 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> > index eeae7a3..6ebec83 100644
> > --- a/include/linux/clk-private.h
> > +++ b/include/linux/clk-private.h
> > @@ -70,7 +70,7 @@ struct clk {
> > =A0#define DEFINE_CLK_FIXED_RATE(_name, _flags, _rate, =A0 =A0 =A0 =A0 =
=A0 =A0\
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_fixed_r=
ate_flags) =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> > =A0 =A0 =A0 =A0static struct clk _name; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> > - =A0 =A0 =A0 static char *_name##_parent_names[] =3D {}; =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 \
> > + =A0 =A0 =A0 static const char *_name##_parent_names[] =3D {}; =A0 =A0=
 =A0 =A0 \

does it make sense to have this as:

static const char * const _name##_parent_names[] =3D { }; ??

--=20
balbi

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmuL5AAoJEIaOsuA1yqREJYMP/3Czt8OckpTHZwQDhyqi/f0l
XIjp2Da/RRl/4vAY4jfTwLAj/R3MipLdBkT7hNIqeXXataScMVZXUj3VgjlFbe1o
dRANh9oV+Il59z2tHgpT4vN+YhCw+bNgxmB8zntJWIK1+EhkV3efxfG0qRM9uQZp
Jyyq+vULWLscwD/ju1U4GY9JqwKeewByzHGgc0VeUrqVQAiEN7w9j/a9k2uZQ9xF
+9zXj7UYNq/KenZunH/sRPIedUhvDrgnC1kgpqK7NhOOLI9MJEWaR/CZhS0PgS1P
5NgF4HvdW9UUGK1cUlYGiOgzadKgXeDlP78+eSJ4yXDLWV/AISGCUz6BoVZSzYt+
Gi6n6hCcseDuphbN/9d7eYFvQxMQDh/ePi+J+sJiJaUSnCfT0dqgogaoAVjC0TzT
IS/QpxN/Z9WWqwtQ5l4TRq41ZOfW1m+7sYlYFxc9pTrw7XD8IDrZ+/07BLFgf17m
VvvagNGYRs3iO4w18cbAkv7SKx3zZAWMOTmb5NRVzadhPhvgNbuHcDQMNgpswqj4
I85yCROMNxJyI8hX4N3yW7wADnub0glo1pSOSTJ4U+inQr/GGC5VBhIdvkt+n1PY
Aj+HhAUue6VbllCMnRl0zHbPWGMcS/YflN6N0HbixuB7LhVwdhu50GwPb6EmZfd3
cF4JNj0GMrYAAj1FWzo9
=iLIb
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
