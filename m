Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab0KYQzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:55:48 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51735 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab0KYQzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:55:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NRSsdYwVh8x1GNEPBRLZ5Dr952tZ7+maApNZVYc02+389KULMQL+ez6lzeiSzq1LBD
         QEUTIgKPSvquAJGGUcsa3fZ4MZEHLiXvgfxdh6XCeIkLPF1ri2NMI9lG9b828U0Yny2B
         aL3IQisk6q2ys4lwBDxquXSsJPs3RS9WWTAOI=
Date: Fri, 26 Nov 2010 00:55:27 +0800
From: "ZHANG, Le" <r0bertz@gentoo.org>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] ipv4: mitigate an integer underflow when comparing tcp
 timestamps
Message-ID: <20101125165525.GA4480@adriano>
References: <1289720156-30118-1-git-send-email-r0bertz@gentoo.org>
 <1289724745.2743.61.camel@edumazet-laptop>
 <20101114.115536.71112799.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20101114.115536.71112799.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:55 Sun 14 Nov     , David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Sun, 14 Nov 2010 09:52:25 +0100
>=20
> > Really, if you have multiple clients behind a common NAT, you cannot use
> > this code at all, since NAT doesnt usually change TCP timestamps.
>=20
> NAT is %100 incompatible with TW recycling, full stop.
>=20
> There is no maybe, or maybe not.
>=20
> If you are behind NAT you must not turn this feature on, ever.

Sorry, this question may be OT on this list, but I am just curious:

Is there any other OS has implemented this feature like Linux?

To be very specific, by this feature, I mean rejecting old duplicates based
on per-host cache of last timestamp received from any connections.
As suggested in RFC1323 Appendix B.2 (b).

Does anyone, by any chance, know the answer? Thanks in advance!

--=20
ZHANG, Le
http://zhangle.is-a-geek.org
0260 C902 B8F8 6506 6586 2B90 BC51 C808 1E4E 2973

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAkzulP0ACgkQvFHICB5OKXOFDwCePUeeQBOqYiZ9rOD431KDYeii
srgAnjkB94rmiHblPYdghTZcttb/JT4B
=76O/
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
