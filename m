Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3AJOnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 09:43:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34012 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225Ab3AJOng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:43:36 -0500
Message-ID: <1357829004.4514.1.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [v2.6.34-stable 60/77] udf: Avoid run away loop when partition
 table length is corrupted
From: Ben Hutchings <ben@decadent.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Date: Thu, 10 Jan 2013 14:43:24 +0000
In-Reply-To: <1357688156-25387-61-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
	 <1357688156-25387-61-git-send-email-paul.gortmaker@windriver.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FMlQtaQiWgdXip2l5xqx"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FMlQtaQiWgdXip2l5xqx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-01-08 at 18:35 -0500, Paul Gortmaker wrote:
> From: Jan Kara <jack@suse.cz>
>=20
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     http://git.kernel.org/?p=3Dlinux/kernel/git/paulg/longterm-queue-2.6.=
34.git
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
>=20
> commit adee11b2085bee90bd8f4f52123ffb07882d6256 upstream.
>=20
> Check provided length of partition table so that (possibly maliciously)
> corrupted partition table cannot cause accessing data beyond current buff=
er.
>=20
> Signed-off-by: Jan Kara <jack@suse.cz>
> [PG: in 2.6.34 udf_err() is called udf_error()]
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
[...]

There's a follow-up I think you should add:

commit 57b9655d01ef057a523e810d29c37ac09b80eead
Author: Jan Kara <jack@suse.cz>
Date:   Tue Jul 10 17:58:04 2012 +0200

    udf: Improve table length check to avoid possible overflow

Ben.

--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

--=-FMlQtaQiWgdXip2l5xqx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUO7TjOe/yOyVhhEJAQr+Jg//YTNVpsR7/hi1vaAPU4vIEEcbd/gtqLpf
GvMYq2+bG3TwdZQlkf5jjE8xK/iNmcBC96fjZUwyonAAL3JejBJC2MClRvtQCn1E
WxY1oAtlxZn3DIa21lewgy7zsw0J8bptTzSZ9xCj5ZVlIf6VCXqEyLz49qGxCOxr
ysXe0lfuv0WYqlfUy+yEtXjX+Uz7XsvOW8JErWgWW+IFZfFiymELIfzX8Rdm1l7r
s2Xztvug99/azoat4YI3bXqejOeRYmZfhpFVso8hpmGC3uZpymIY7Opxnr118dAw
c1dvLCkhZxO4VMsO+iIVlWck4PTDAZCFgt9I9enCMIFroYZCXC5OGkGJZVx5Xo28
JAKAC8GHRpY3k3V3QrZ4phNAiQL/CausY5J7Jrr4d3tTm+VfQgjFYak3fkqm48te
WAAbGqPATv4NxU419+6fu3hyqtXKWR/cycEu67m4+7Lqb0U4qxPyoF5jnPSfQCkr
esVr2j6QEqC3KyOi1neuMJ6ehpm3pPe/jD+LhrCtJixmRUyLCM/T78fzLb+LBAB+
g8MObnavsKmZ8pyw3PAUfoXBl2DuopAV4by37fGCaXmV1237911WDMyeZEd34Afb
t1WTZUadYQc+Gkcz595HBAIf4geJJM6wgopSslYqZCSLfvK5Md+cVwlhED/i5Ezi
M1oa46AWcww=
=6U4L
-----END PGP SIGNATURE-----

--=-FMlQtaQiWgdXip2l5xqx--
