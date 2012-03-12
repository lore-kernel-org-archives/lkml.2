Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab2CLPZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:25:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59092 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673Ab2CLPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:25:35 -0400
Message-ID: <1331565925.3022.157.camel@deadeye>
Subject: Re: [ 02/12] Remove COMPAT_IA32 support
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Mon, 12 Mar 2012 15:25:25 +0000
In-Reply-To: <20120312063027.GB8971@1wt.eu>
References: <20120312002046.041448832@1wt.eu>
	 <1331514446.3022.140.camel@deadeye> <20120312024948.GB4650@kroah.com>
	 <20120312063027.GB8971@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-lF73H5zMu4/TBORrBgXe"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lF73H5zMu4/TBORrBgXe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-03-12 at 07:30 +0100, Willy Tarreau wrote:
> On Sun, Mar 11, 2012 at 07:49:48PM -0700, Greg KH wrote:
> > On Mon, Mar 12, 2012 at 01:07:26AM +0000, Ben Hutchings wrote:
> > > On Mon, 2012-03-12 at 01:20 +0100, Willy Tarreau wrote:
> > > > 2.6.32-longterm review patch.  If anyone has any objections, please=
 let me know.
> > >=20
> > > The subject/first line should include '[IA64]', as in the original
> > > commit.  It looks like this has been automatically stripped.
> >=20
> > Yeah, munging patches to and from quilt and git will cause that to
> > happen at times, it's quite common :(
>=20
> Indeed, and I've even changed my patch formats in haproxy to avoid bracke=
ts
> due to this issue. The cause is that many patches are sent with a [PATCH]
> prefix and that with Git, either you keep the subject line intact or you
> remove everything that is between brackets. There's the -b option to only
> remove remove tags looking like [PATCH], but my general experience with i=
t
> was not satisfying (I don't remind why). I have added some scripts to do
> this at some points in the process but it's not 100% reliable as can be
> seen here.
>=20
> The "funny" thing here is that this comment lacking any IA64 tag annoyed
> me a bit, and I was about to change its name then refrained from doing
> so because I prefered not to keep the original message intact as I did
> not notice the tag went off on my side :-/
>=20
> Ben, I strongly suggest that you too switch your practise from "[IA64]"
> to "IA64:" as can be seen on many kernel commits these days.

That is my personal practice.  But I copied this subject from the
mainline commit.

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-lF73H5zMu4/TBORrBgXe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT14VZee/yOyVhhEJAQoz+A//QQuhKj3mJPaJnDdR/8nFqwWi7AI7yEH3
tQTN7JQTY2odu44m3p+yQmZ+s9xK9U+byj2QLXXwi51g2C/dkDSi2OY+SuYXdBDS
6qkpa9bSRbpBC7BpJS7K3ZXxVBB9HbHostvdSZ2fADg17qjNRC0JGShjCzwc7HCO
pQ6y2KVXCcmcu4bB41DRy+S3bAdDgAB+fjYTSiehXSPi8LZtsG6Yw6rguKMLz6hg
EeHy//KPr1aEO9UcgZrTE6OkALLChArmPWUj89pNBi9y2LWkPInWGWxC1DxuyMo8
vKHApoogLBSaxtSpAGmmX4J0vx3vRXOhioWeAblnOUj1MVsmesv4Tduf0mLv1OuF
LuX381Im8DUCwXZER09ywQozmyhsc6m1RkGd7YnQVy8oVG/AIXw+HeMbiR280JGj
owbPszUN2Sq1vgNPzkj/702qF4AfaaxoPgIGhoq1JGinphiJ7gEnDHHgoRYzSs9e
qZPqm/fMH1nZuSZoCUvxGCH9OvYtO1kzuKc15pBxwP1dkFOdIuIkkv8xqNckJaQV
FA963+EYpKppHZTG15FvHOt+BB+opuKsbN+n/bdx8NDRqTJH3n4tw4WdUQnBBURJ
sNEd+/tGRpENOkMzbftpQH9IgUPoPlBiD0fTdDSi9UE90IOa7haFE0uFJZJg0Vg7
ai/xeZWQeQs=
=kCNl
-----END PGP SIGNATURE-----

--=-lF73H5zMu4/TBORrBgXe--
