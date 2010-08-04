Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab0HDJYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:24:17 -0400
Received: from mailsrv1.zmi.at ([212.69.164.54]:42269 "EHLO mailsrv14.zmi.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253Ab0HDJYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:24:15 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 05:24:15 EDT
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Organization: it-management http://it-management.at
To: Dominik Brodowski <linux@dominikbrodowski.net>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: How to track down abysmal performance ata - raid1 - crypto - vg/lv - xfs
Date: Wed, 4 Aug 2010 11:16:09 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34.1-zmi; KDE/4.3.5; x86_64; ; )
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
In-Reply-To: <20100804073546.GA7494@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart41331569.taeFQ0rjha";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201008041116.09822@zmi.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart41331569.taeFQ0rjha
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 4. August 2010 Dominik Brodowski wrote:
> The read performance is abysmal. The ata devices can be ruled out, as
>  hdparm
>=20
> resulted in acceptable performance:
> > Timing cached reads:   9444 MB in  2.00 seconds =3D 4733.59 MB/sec
> > Timing buffered disk reads:  298 MB in  3.02 seconds =3D  98.73
> > MB/sec

Has that system been running acceptable before? If yes, what has been=20
changed that performance is down now?

Or is it a new setup? Then why is it in production already?

Can you run bonnie on that system?
What does "dd if=3D<your device> of=3D/dev/null bs=3D1m count=3D1024" say?
What does "dd if=3D/dev/zero of=3D<your device> bs=3D1m count=3D1024" say?


=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart41331569.taeFQ0rjha
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxZL9kACgkQzhSR9xwSCbTecACeIaIGfwqb9W43UiPu6DtTRiXr
RWQAn0J6cBGwcUqCSGFRDblkJA/XaA/s
=7bjv
-----END PGP SIGNATURE-----

--nextPart41331569.taeFQ0rjha--
