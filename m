Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2GDEbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 00:31:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42675 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab2GDEbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 00:31:33 -0400
Message-ID: <1341376279.4852.168.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 11/48] mm: correctly synchronize rss-counters at exit/exec
From: Ben Hutchings <ben@decadent.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 04 Jul 2012 05:31:19 +0100
In-Reply-To: <20120702164655.GA15285@redhat.com>
References: <20120701172008.252571630@decadent.org.uk>
	 <alpine.LSU.2.00.1207011150480.1905@eggly.anvils>
	 <1341194519.4852.128.camel@deadeye.wl.decadent.org.uk>
	 <20120702164655.GA15285@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0AbMnQg92gfp3CiCIRbW"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0AbMnQg92gfp3CiCIRbW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-02 at 18:46 +0200, Oleg Nesterov wrote:
> On 07/02, Ben Hutchings wrote:
> >
> > Then I'll assume this should be dropped unless Konstantin or Oleg speak=
s
> > up for it.
>=20
> Just in case, I agree with Hugh.
>=20
> The patch should shut up check_mm() which doesn't exist in 3.2

Thanks; I've dropped this.

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-0AbMnQg92gfp3CiCIRbW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/PHGOe/yOyVhhEJAQrOyA//cHz9tum2R1roOiGKkHJ6gY0sNeRzLkWw
u9AfWcJfQHds+iLaD27t1nNKxBPLf0QYCew/GRMneaImO+NDr+J1dt4PAa+LlIjb
+2a9YFonqFp6oIQGiZdOrXqzyzKKIU5xqKY3qyIC5lN0Z1+Igu3Qk8cAteqlNZ3p
ObqEpKr5h5uBFa/Yc1aVvpNEJMeT4d1glo+Z5/8JAMzYkGD+v3z3SGKoHov0POxb
s/nD4ECtputZUtZm2P9osVtEGzWYFz0l+XCQY21hJQrw3Vjqctjdod4Xq08WXxIh
+Ysimt6ZPiIssPK8etDLO/kWv9rYTGdVOzQ3otyuW4J19je/qvI7R4rDVAG434P/
+2LXfA4+LbOFuEHT2JVUFbUb2k+CL4Zo7MN7NgwSFL9hxtt3N6I35E7PBnEiumJ2
ffdDGeBvoHwof8vy+2zI35MpmEeBJqwnR6ubvUspmgN+uzJUkEdrNXBM8TkcFm2k
X9HoCH44anCdaqk7HELeMP9vR8+0ZFZnJLbgujopZAZJ9j40xo1zRKJ6cVTVqhXE
yjeV1QOeLxMNccN6dvU714fjyatNQZ9H6XXI9elKLIAXNNHkDsxoIRRsBTDlKeqI
QF77V+LCmwjLxdRVoeMos3t6wLKQNwcyRiiEBhwNn9GJElGzySS8y0YZIYqpjYzz
iuDSgPeW9c4=
=xKT6
-----END PGP SIGNATURE-----

--=-0AbMnQg92gfp3CiCIRbW--
