Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1DUExN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 00:53:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40106 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248Ab1DUExL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 00:53:11 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Nick Piggin <npiggin@kernel.dk>, David Rientjes <rientjes@google.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
In-Reply-To: <20110421132442.7327.A69D9226@jp.fujitsu.com>
References: <20110419201048.281575300@clark.kroah.org>
	 <1303357246.3464.136.camel@localhost>
	 <20110421132442.7327.A69D9226@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-FxyDe/txCSILQR5zxJj8"
Date: Thu, 21 Apr 2011 05:52:59 +0100
Message-ID: <1303361579.3464.168.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [48/70] vmscan: all_unreclaimable() use
 zone->all_unreclaimable as a name
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FxyDe/txCSILQR5zxJj8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-04-21 at 13:24 +0900, KOSAKI Motohiro wrote:
> > On Tue, 2011-04-19 at 13:08 -0700, Greg KH wrote:
> > > 2.6.38-stable review patch.  If anyone has any objections, please let=
 us know.
> > >=20
> > > ------------------
> > >=20
> > > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > >=20
> > > commit 929bea7c714220fc76ce3f75bef9056477c28e74 upstream.
> > >=20
> > > all_unreclaimable check in direct reclaim has been introduced at 2.6.=
19
> > > by following commit.
> > >=20
> > > 	2006 Sep 25; commit 408d8544; oom: use unreclaimable info
> > >=20
> > > And it went through strange history. firstly, following commit broke
> > > the logic unintentionally.
> > >=20
> > > 	2008 Apr 29; commit a41f24ea; page allocator: smarter retry of
> > > 				      costly-order allocations
> > [...]
> >=20
> > So presumably this needs to be fixed in 2.6.32.y and other longterm
> > series as well.  Though there seems to be a whole series of fixes
> > required in 2.6.32.y!
> >=20
> > Are you going to look after that, or should someone else prepare
> > backports?  (I'm certainly not volunteering - I don't have the VM
> > knowledge to work out what needs doing.)
>=20
> Hi Ben
>=20
> Honestly, I didn't prepare. If my remember is correct, you are debian=20
> guy. So, Can I think the backport 2.6.32.y help debian people? If so,
> it's good thing to increase my priority to do this.

Most of the 'enterprise' and long-term supported distributions (Debian,
Ubuntu, SLE, OEL and RHEL) have kernels based on 2.6.32.  RH seem to be
doing their own thing but the rest of us are using 2.6.32.y as a basis.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-FxyDe/txCSILQR5zxJj8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATa+4K+e/yOyVhhEJAQoAZBAAgqa7/TIJ7Jf9Euym+B9oh/vl+hJXvS3z
I3llJzL1cZLm9MO0CPvcMV7g2qNJ/4qQrL8GYMzIP4F5iq+BCQqLWM6uQLvy59s8
+FHRYF9chJgV3ff3SFDyF0G8ByWvPN+jmyzSFPeEA4MIOO8toHVOECNX89Dsx2Gh
WookGU3LHurnWRpcLRxODtE2J/5Z0oD1Vlm00B7rhtN3Sp1sJGTfRinxAWNDDK1V
KqyDMuKGpTtLTg0uYg3UFqLLj+EKTx+1YCcn52FVRLhWtcvVE2jWu6hxgBZbL7eb
Fmh1ssZ6ljMx+EMD9lcfIVvzy+/yY0Fb6Sh84G66wKFqYFA5tsfd3owXOZrmrCD9
qfR3Whb7sCZ8EM+l2UhPzQI3tkSH/dr6ukPjkL3THt0JRN3uDagSDw+JZqH4477W
hOErkGxIEZBBWKxTVghVVTQzAyEGHhxhmkTt1u7f7eiyCBNRNXq+b0A7edFV1Rkn
Cmy0Xf4qg/doe0F/1cEMmWzZGJiVy2MHO7VVevb0l/Wi33nLxxa1esullt4rPuz9
3P0/ZS5tOCs/nVnlRRXDjwQ8y5zjkeLrSCfALcKmF0LmrInkN8ubnOmoi43ysG3k
aetOk5C/aUHDAEOjbuWCerURLqBYCAvnlCBQ9O499FVsindPluKyFgiaxwvMjRcW
rAMlyvQiBVo=
=jn41
-----END PGP SIGNATURE-----

--=-FxyDe/txCSILQR5zxJj8--
