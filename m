Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2BFVKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:10:37 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47201 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2BFVKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:10:35 -0500
Date: Tue, 7 Feb 2012 08:10:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: dedekind1@gmail.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: linux-next: build failure after merge of the l2-mtd tree
Message-Id: <20120207081026.2f488c285a0dee36a0b03c63@canb.auug.org.au>
In-Reply-To: <1328519654.22240.31.camel@sauron.fi.intel.com>
References: <20120206120706.cf5d951972d22eb7fa134fbd@canb.auug.org.au>
	<1328519654.22240.31.camel@sauron.fi.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__7_Feb_2012_08_10_26_+1100_B9Q9CWBZu_GMIgRs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Feb_2012_08_10_26_+1100_B9Q9CWBZu_GMIgRs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

On Mon, 06 Feb 2012 11:14:14 +0200 Artem Bityutskiy <dedekind1@gmail.com> w=
rote:
>
> On Mon, 2012-02-06 at 12:07 +1100, Stephen Rothwell wrote:
> >=20
> > drivers/mtd/devices/pmc551.c:191:12: error: conflicting types for 'pmc5=
51_unpoint'
> > include/linux/mtd/pmc551.h:37:13: note: previous declaration of 'pmc551=
_unpoint' was here
> > drivers/mtd/devices/pmc551.c: In function 'pmc551_unpoint':
> > drivers/mtd/devices/pmc551.c:196:1: warning: no return statement in fun=
ction returning non-void [-Wreturn-type]
>=20
> Thanks, fixed. I am doing rather massive MTD API cleaning, so new small
> issues are possible.

You fixed the header file, but not the fact that pmc551_unpoint() still
doesn't return anything ... Warnings are there for a reason sometimes :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__7_Feb_2012_08_10_26_+1100_B9Q9CWBZu_GMIgRs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPMEHCAAoJEECxmPOUX5FEyHEQAJpMwvAGOB4Puzhsocl5BWPW
tpxShfsr7cMqm175SlfUTxC5cGvpJg3dM5BTzkEpNsPJ3XM6t4OpufQZiyRVioYK
Gg5BUGigfNckec4r+g5OCTg2wRiAmPz+9QC3yUDVR9sON8OghuBd9h+ySlc24r7M
frUXN4+GaMVvPwDctZq0deZ+btNg+tad5wTDAcMmR0s+c3LLrqHfNJgpHbtVd0g2
3W7vbffzuUlZX8qa3J3EoiQ7YdrJMqVKG5RyGVV1SkrI1xwP21LEXXhBe1KEheC0
T051H8ZK8rpkt5k6rjpG1yMW3UHzcDgyTMiEsgUUKruePe1nJW73EMzlX+2yj7so
fW4sCwEL7z6ZBn/7aN4kB1LKBtvorEzeAmk4XPZRIvXmJ35M4PI2AYQvY27eEsIJ
fiO7fCQHfQ8aopDjQ3XyVwJVjtkETu/VVr2E9pWFpTPi9lYP3M8Aq4Zhh0MByg9U
P7W2B4wjZahz33tNE1XbOeftPFl0pfVjLRntPDgfEFJ6Wn/JIryX8tnZOc2h8xex
6p3Wm+U9IFLBlNEae5rXajP+6FNulnDK4Bkc0D1NCBF5PYNQOmQN8SItwiyB7nIZ
M79v1gcsxxWtxjhtp/1N5YtVW/e6zcMCzNx9adEkBkSyWQeSP1uqqKnvAglL762h
JyzRCBh/J9R1hKaKoTJj
=zEda
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Feb_2012_08_10_26_+1100_B9Q9CWBZu_GMIgRs--
