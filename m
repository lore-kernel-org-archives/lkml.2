Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1FITkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:40:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41998 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab1FITki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:40:38 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: u-boot@lists.denx.de
Subject: Re: [U-Boot] [RFC PATCH] checkpatch.pl: Add ability to ignore various messages
Date: Thu, 9 Jun 2011 15:40:35 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39; KDE/4.6.3; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <1303713156.1745.38.camel@Joe-Laptop> <b41636a5e5756917b07e50a4b8309dbb092b0a17.1303778411.git.joe@perches.com> <1307647606.13329.40.camel@Joe-Laptop>
In-Reply-To: <1307647606.13329.40.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4600367.9i1e4IW6rc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201106091540.37573.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4600367.9i1e4IW6rc
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday, June 09, 2011 15:26:46 Joe Perches wrote:
> On Mon, 2011-04-25 at 17:43 -0700, Joe Perches wrote:
> > Some users would like the ability to not emit some of the
> > messages that checkpatch produces.
> >=20
> > Add command line option to "--ignore" various message types.
> > Add .checkpatch.conf file to store a default set of "ignore" flags
> > Categorize all ERROR, WARN and CHK types with flags.
>=20
> Did anyone object to this?

i'm all for this.  i could use it elsewhere too.
=2Dmike

--nextPart4600367.9i1e4IW6rc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJN8SG1AAoJEEFjO5/oN/WBjXEP/jlttCaM8CWc90+rOl67jj7h
29vXc8IfWEFjoO3cRzBQZMIyRSlgG1fsBtO+A4Y/g7g2No6E/Jgx226OB6HJoJkx
56E0Gm9NApejRy9hej9B7A1KVWue3AAZcRoMoHqzVKXiR1L1qEZ5Ny6v0GD//I5h
3G77zFSmi8PIsVML694jlciUGBmBNa1642UHGSSjqAJiPQpVlzmHPknOtZ6WXM7Q
i5SvYtYLaPNOqBYTjH0SjUKyDFjHkh5w309uEeeRS6H5GZ+km2PGc3BOUqlWSkrq
qFeKdfx5t6s+Hk3c5XV5aqEpmtJijgD2p/+gra+pxgtiD2uwfH4wW0BGozcJby03
WKlKcw+IEb2JafIsHs7BSGSzIJaHvS0aPtmp4pfDMCB0SsrIQvBeeteBAwLdFwyX
Gi+2IbE/xyY2IdnxybU039y05HMyux8SQfigWef8kqLGzCxl5MPDoU3gM+VY98mb
wJh3PtqOw5wit0uwZ6gkmQ7TYRtf08t+H9re4hxkXpRd8/Z5ygoPeDjScfML7hgj
CbNk68Ah7906jH7j32zOXrD02948Pvr5UQzd/ez0F14KmZxGqe4a+QkNi3VwkrRy
zqBbJEqoAhQMQSgLQQ0lO+RAhboKgwth4iwQEYHyoD5w/fQ9jqMXwWC7OnSv/tb/
FnUkeBLx73BFYpg5QRO4
=xQBI
-----END PGP SIGNATURE-----

--nextPart4600367.9i1e4IW6rc--
