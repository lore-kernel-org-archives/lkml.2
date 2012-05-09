Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2EIDHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 23:07:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37541 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521Ab2EIDHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 23:07:13 -0400
Message-ID: <1336532828.8274.340.camel@deadeye>
Subject: Re: [ 57/75] exit_signal: simplify the "we have changed execution
 domain" logic
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Wed, 09 May 2012 04:07:08 +0100
In-Reply-To: <20120508003125.GC4150@kroah.com>
References: <20120504204229.240075699@linuxfoundation.org>
	 <1336355835.8274.262.camel@deadeye> <20120508003125.GC4150@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bPU5R06eLfopLPa/CTCZ"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bPU5R06eLfopLPa/CTCZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-05-07 at 17:31 -0700, Greg KH wrote:
> On Mon, May 07, 2012 at 02:57:15AM +0100, Ben Hutchings wrote:
> > On Fri, 2012-05-04 at 13:43 -0700, Greg KH wrote:
> > > 3.3-stable review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: Oleg Nesterov <oleg@redhat.com>
> > >=20
> > > commit e636825346b36a07ccfc8e30946d52855e21f681 upstream.
> > [...]
> >=20
> > This and the following commit b6e238dceed36891cc633167afe7151f1f3d83c5
> > ('exit_signal: fix the "parent has changed security domain" logic')
> > appear to be applicable to 3.2.y as well.  Should I queue them up?
>=20
> Yes, that would be good to do.

Done.

Ben.

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-bPU5R06eLfopLPa/CTCZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6nfXee/yOyVhhEJAQqiNQ//QniB2/BaAyYVGyDaVbJZRxX+3mPST7iw
RwoaU0PoBtZ66z7H6X/7xB14MoXA3ocfy2v8Z4LaO3BG65MDw8H+ujdH9RQsWPqy
j+Q7yht2H2eDrRxPr7VyviEpkgt1T+PPKC6TV8My+mnawQlQ6aU0DDosz7AmfSdq
x1I4bppVjKbZX9VAr71KFDMc3jHCsZa30M+v8CAhG2kLtpAXPncrbkuVSRB5h7yl
7vorEuw/iB869XrRa2xvCHEy4KCc6sQKuXvLwT8DD96qXPOI0ZZxeaFPj2GLPXh1
7zzhtXZlnJAmHDijuwKuUU39UDhd2VX4YrpFapEsLb52lCtEWvXH6zwjrVIvp3Zj
51TLBR2YVhSkNLxlzUdIuREgXFdVEmjAihksbvzUMS7ZMEt8iNfgIflcJVZvUGfX
ZxGgTe+3STQtWfZb4KW0FNdzw9HuvabWZ3DgUUpNEzTbEGd0Y/+cCycJlhUyKyOZ
FoUgUjGhPMsEP8DuuMpI1OdNVF5XNnynvq8HeOiS1x5uadKBvMB9KV/i15eTd+cB
SVDKLeKmPt/63OAgPuuH2Xl+6UZa5EKOnn/qIjJQExNtFuSrWShfc6NIjIguVLjL
Y4mnmAgMQC7A9zz7YdtlRH3pKcZZMPDWpAq9jkCPpEL5acjFtuggqgtMC2E3QjpA
+9Y/UwQm6AQ=
=DqWW
-----END PGP SIGNATURE-----

--=-bPU5R06eLfopLPa/CTCZ--
