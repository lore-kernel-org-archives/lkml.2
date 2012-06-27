Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2F0BwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:52:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58074 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755778Ab2F0BwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:52:00 -0400
Message-ID: <1340761909.5330.23.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] dm thin: reinstate missing mempool_free in
 cell_release_singleton
From: Ben Hutchings <ben@decadent.org.uk>
To: Touko Korpela <touko.korpela@iki.fi>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Date: Wed, 27 Jun 2012 02:51:49 +0100
In-Reply-To: <20120622162127.GA19624@lisko>
References: <20120622162127.GA19624@lisko>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vH84KpogmLzEm3A/m/s/"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vH84KpogmLzEm3A/m/s/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-22 at 19:21 +0300, Touko Korpela wrote:
> Greg KH wrote:
> > On Fri, Jun 22, 2012 at 10:59:48AM -0400, Mike Snitzer wrote:
> > > Hi Greg,
> > >=20
> > > 3.3-stable pulled in upstream commit
> > > 6f94a4c45a6f744383f9f695dde019998db3df55 (dm thin: fix stacked bi_nex=
t
> > > usage)
> > >=20
> > > But later in the 3.4 development window it was determined that that
> > > commit introduced a significant leak.  The following upstream commit
> > > fixes it (but unfortunately didn't cc: stable).
> >
> > 3.3 is end-of-life, so there's not much I can do with the 3.3-stable
> > tree anymore, sorry.  If there's any other tree I should apply this to
> > that is active (i.e. 3.0 or 3.4), please let me know.
>=20
> Looks like you forgot 3.2 that is affected (since 3.2.14).

I've added this to the queue for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Lowery's Law:
             If it jams, force it. If it breaks, it needed replacing anyway=
.

--=-vH84KpogmLzEm3A/m/s/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT+pnNee/yOyVhhEJAQqY+xAAnr4mEhuF7iyoI75suZCqw3T0C8p3cNnX
UXw7sxaIgWaYQfduzd+OgE7+ksj0sYCbfZ8uzz84z6SwQVHXc02YkkTj5qDzMpn4
TtriRKcLiFgmeF8TfKeyQeR9Hvdz/xppzXkEAgoEyK67CRQRX01CrUKuLUiV5oUK
J476kf5ve1B4c5WZtwZtoj07Dg0q9juF0vY6lgVC4tN8pqqfAEx2mq6vv4b8NgpT
UZSgylgX8UrVvzR5+gOLE238b48H+1snP71BUi1mK6hxOT7gcAa0FWq5ICa1uq2p
as/DDlpqBjI3nnWMxyHfQ5oKhCvXTwdjy5Xrq6+PNk8mk46npInauIfe96NHoprz
t1aYnMtHge6kkCJZgP8/NeLHwzXOea3ozUljbCdq5R4vM2UntE1eKLCrfS1EvUPF
/9z9P0CgJDWicVjER5Dps5+UgIS3UTp8GZNhHyttaGRaX/1x8eq6Bkpo+KeY4Ksz
7Bax3bNCnKjVKU6fpD/JL+LHy+2/wn1THi+wOMMsNDiSxS4VRwIOXzqhn2gla4BW
CXpI6fNk/HeLHkczJiuJAfR1HR6RJRoGnK2TKasMNsWSGIXYISjNBO+EDVoWjQ44
NDEJdq9vcX5vAL0C1m9bKLMPKO8XPNVUFRbL0txRO4sfEE9CZ5fP5eFNJQXVjSwH
/iLmGj+k3ds=
=MwtK
-----END PGP SIGNATURE-----

--=-vH84KpogmLzEm3A/m/s/--
