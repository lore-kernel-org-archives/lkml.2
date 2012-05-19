Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab2ESAbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:31:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932552Ab2ESAbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:31:46 -0400
Message-ID: <1337387496.4107.110.camel@deadeye>
Subject: Re: [ 12/53] net: In unregister_netdevice_notifier unregister the
 netdevices.
From: Ben Hutchings <ben@decadent.org.uk>
To: David Miller <davem@davemloft.net>
Cc: herton.krzesinski@canonical.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        ebiederm@xmission.com, eric.dumazet@gmail.com
Date: Sat, 19 May 2012 01:31:36 +0100
In-Reply-To: <20120518.014131.519437851000725829.davem@davemloft.net>
References: <20120518023254.339945758@decadent.org.uk>
	 <20120518023255.978828329@decadent.org.uk>
	 <20120518050904.GA2971@herton-Z68MA-D2H-B3>
	 <20120518.014131.519437851000725829.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+IW4jNr8PpKXCrMjZrd/"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+IW4jNr8PpKXCrMjZrd/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-18 at 01:41 -0400, David Miller wrote:
> From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> Date: Fri, 18 May 2012 02:09:05 -0300
>=20
> > On Fri, May 18, 2012 at 03:33:06AM +0100, Ben Hutchings wrote:
> >> 3.2.18-stable review patch.  If anyone has any objections, please let =
me know.
> >>=20
> >> ------------------
> >>=20
> >> From: "Eric W. Biederman" <ebiederm@xmission.com>
> >>=20
> >> [ Upstream commit 7d3d43dab4e978d8d9ad1acf8af15c9b1c4b0f0f ]
> >>=20
> >> We already synthesize events in register_netdevice_notifier and synthe=
sizing
> >> events in unregister_netdevice_notifier allows to us remove the need f=
or
> >> special case cleanup code.
> >>=20
> >> This change should be safe as it adds no new cases for existing caller=
s
> >> of unregiser_netdevice_notifier to handle.
> >=20
> > It seems this introduces a regression later fixed by commit
> > c57b54684060c8aced64a5b78ff69ff289af97b9
>=20
> Indeed, but thankfully that only hits people who try to unload the
> pktgen module which is a pretty small group of people :)

Surely we ought to avoid introducing a known regression.  Though I also
see that that the above fix for pktgen was incorrect and the
fix-of-the-fix (d4b1133558e0d417342d5d2c49e4c35b428ff20d) is not in
mainline yet.  But if the latter reaches mainline by Sunday, perhaps I
could add them both?

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-+IW4jNr8PpKXCrMjZrd/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT7bp6Oe/yOyVhhEJAQoRwA//QiMpfcIQERor6x1agicpho531HkigB/7
JAZsPMWR9Iz1WnFQE/R7CO6Fj/9byD1Qefy/s99TjjSR3+2gzfNewWbfdrIkhGRG
YJLzGpxEJXQicFgo0NTXLOG9hje3gfhvXVwM0tMRCpGvzeZJLfTK86S6DI4DmGxP
lo0MxiumrOB/Uu2nQmGMMur3NooPYRcPUfviJL6A4dUBgxx64WGKqKocUtgywjj8
9eDOMx6NQRucNxsAU6404wxce0BdOX7yqnUhEQlopPgESVeEL5Lsn0QXEDhFaHPQ
dlMW58S3jxqORFnYFgF9mTPAe0QZuM4L59ahcrMlLExl24DNZMS2b9DQaN+SMqya
g2AYQfhMo6dX3WtRsmDQr8nRjqGh3roU4ojNcFJDd+RSYs0357JxVEFDAugE5Shb
0wYKr6/W53ej8u3dx2uwu/rCwVcuIKYQPJAqz2kjLrzKNIuiaCQVzELKd8s7zVZ2
MjwwMRggvMy5zq+H375GLrL+mRjibMUcr70MmuQiD3vmFILT+ML6TLplaDwdkHAE
ITA+nx3W2u56RutMhHTy7yDH9Kn+7/3KeAIRhAbgy2wOa5w24C9yiO9HSPSSocVR
Q97m3PLIhcudIZisIKx4qDFohbIkHjiPhTjcKaWMmPz2tkkGd8K2sFvn/k/Y7SJw
UNQyB2eMTyo=
=/t7p
-----END PGP SIGNATURE-----

--=-+IW4jNr8PpKXCrMjZrd/--
