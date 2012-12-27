Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab2L0QKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 11:10:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44364 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752999Ab2L0QKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 11:10:07 -0500
Message-ID: <1356624598.17740.4.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [v3.2-v3.4 stable version][PATCH 1/2] ring-buffer: Fix NULL
 pointer if rb_set_head_page() fails
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Date: Thu, 27 Dec 2012 17:09:58 +0100
In-Reply-To: <1355337871.17101.340.camel@gandalf.local.home>
References: <1355337871.17101.340.camel@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Km+zNjG+ahu0FC0AlFa9"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.210.143
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Km+zNjG+ahu0FC0AlFa9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-12-12 at 13:44 -0500, Steven Rostedt wrote:
> The function rb_set_head_page() searches the list of ring buffer
> pages for a the page that has the HEAD page flag set. If it does
> not find it, it will do a WARN_ON(), disable the ring buffer and
> return NULL, as this should never happen.
>=20
> But if this bug happens to happen, not all callers of this function
> can handle a NULL pointer being returned from it. That needs to be
> fixed.
>=20
> Cc: stable@vger.kernel.org # 3.0+
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[...]

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-Km+zNjG+ahu0FC0AlFa9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUNxy1ue/yOyVhhEJAQrAxg/+JEMhd4Rpbrk1kjgmO+w0P4fo/KLHlxFl
531ihJK7mqk7aGnr5Ejyd0nDg67OryyueiYTjW6aUax3+sqPK28Ue9kNLo9dsywW
9d8VN8REQDvQcoE7vtu3lp+3WBvGQmFP3mnunzSUcXLyadRUmAjdn3YmYbaUWaDi
zsMgcf/omNjraYWd9E8lk0Ir03sE29utP2L0kW69qNNwuEotnhDUcAI/w5lHsWho
GV1BfCJWu8SkoJs5nZCHB+ZfzzkoeOt8dLeg8ogITXv4iOyYNKKDddA1ue5lhhxC
1bSgvLj40HeVn64gc5JFKsxakq9qBUsIUse8glWFFVjM/ioozp/FkRRWZYqjTc33
4qdoYWElG5WrmY9O6u8MNPgi4scTZM9tybKhQEV+9R18I2xyXJhiMCzTNL+8x/h2
RdKEUSgVUy5SHvXQ1RdVj+b7tNp7eUu/faBHFUXxihZMzTCxPDtJagBYH0EQPRZC
KzBRUHeKRF93HF4aufJxW8jec1dLwDcXKQiCFHp0tatx+2MEAevvaH237kxcDGPB
4T71MjGCiVamMIvChtal9Qfdckg2J1e53yvAcG4JPwZx0i3YXDF5nKjNhaGvpMRA
/M1YdVlyTsOMHTsJGdI0iOm9zeA8OJ4jBjXv+7d8IgBVUwQths84UgXKnGFwvE80
CsUW+6td7YQ=
=dRpk
-----END PGP SIGNATURE-----

--=-Km+zNjG+ahu0FC0AlFa9--
