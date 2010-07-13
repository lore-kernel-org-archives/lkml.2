Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab0GMX6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 19:58:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42452 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390Ab0GMX6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 19:58:05 -0400
Subject: Re: [Stable-review] [patch 134/149] x86, paravirt: Add a global
 synchronization	point for pvclock
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Palfrader <peter@palfrader.org>
Cc: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Zachary Amsden <zamsden@redhat.com>, akpm@linux-foundation.org,
        Glauber Costa <glommer@redhat.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
        alan@lxorguk.ukuu.org.uk, H Peter Anvin <hpa@zytor.com>
In-Reply-To: <20100713182527.GG15122@anguilla.noreply.org>
References: <20100701175144.GA2116@kroah.com>
	 <20100701173218.125822294@clark.site>
	 <20100707124731.GJ15122@anguilla.noreply.org> <4C359D5A.1050906@redhat.com>
	 <20100713102350.GW15122@anguilla.noreply.org> <4C3C68C8.4060409@redhat.com>
	 <20100713141902.GB15122@anguilla.noreply.org> <4C3C8CE5.1080705@redhat.com>
	 <AANLkTim_xKrPSTNqS3JWipjlAkmeDnlEYcHt1cn90ggB@mail.gmail.com>
	 <4C3CAAC6.501@redhat.com>  <20100713182527.GG15122@anguilla.noreply.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-abN6t/cU8Ln/vGpp9sXp"
Date: Wed, 14 Jul 2010 00:53:46 +0100
Message-ID: <1279065226.12333.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SA Timed out after 240 secs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-abN6t/cU8Ln/vGpp9sXp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-07-13 at 20:25 +0200, Peter Palfrader wrote:
> On Tue, 13 Jul 2010, Avi Kivity wrote:
>=20
> > Well, current upstream uses "m":
> >
> >>         case 8:                                                       =
  \
> >>                 asm volatile(lock "cmpxchgq %1,%2"                    =
  \
> >>                              : "=3Da"(__ret)                          =
    \
> >>                              : "r"(__new), "m"(*__xg(ptr)), "0"(__old)=
  \
> >>                              : "memory");                             =
  \
> >>                 break;                                                =
  \
> >
> > and works; I also failed to reproduce with 2.6.32.16.  So I expect some=
 =20
> > toolchain involvement.
> >
> > Peter, what gcc are you using?
>=20
> gcc (Debian 4.3.2-1.1) 4.3.2

The experimental Debian packages of 2.6.35-rc5 are built with gcc 4.4
and they don't have this bug - last_value is marked as 'b' in
System.map, which I assume means BSS.  So this may be specific to gcc
4.3.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.





--=-abN6t/cU8Ln/vGpp9sXp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATDz8iee/yOyVhhEJAQLj/Q/9FubkKlDEYbJ8CSUKPbQTY5q7thrXsE+t
HfjSc+r+KRYMxPbdaNSLIokDhjhV3Ae9H9ivOfLKXjck5a2nmBKaIvKa7Ew4QprP
5bYb2cNoZxoVspgp5c3kSoQs2bWUTHUOr/uT2ImAZVXuJyckprUs9CwqfNjaqHJh
Gek2ZhFWB5dQQBi/j0lJk1flxEhQzuVmXzCnjuong/Zj4VUwATqG/JWan70iqQTr
xnPaIEhMdhFIu/gWROTNEuexANNPla48Jjh8L8n3+smfdQU9/dXg2O+lAmSSBg57
dEH5+CiIT9ceeIULjotlXFqfcr2U6sSHneW6HalaqvmJHrVt1sDls5mUVY60Wj7P
FWI5dtqX52vITmy5Tkxgx0ccqUCTcscTES7E5I4ZNHbIqlbfEfKL8FYPfI7gMmgL
n4W8jfTipOfr1tyqBYZtt2GkxfJ6Dtua1CTEXvY3M9y0kt3e1hHvrbt9Uqm13o1L
r4sCnmLx/G5yIknsqyl6WFNNQ2X1ngnOW8WW5F9kevYWMMj2FnkUauCNr0wq9Hxx
xGJYay/FLfEYI9aC9TlX6uiwZBGdkIzQKMZq+lIgmb61NHYvYTGDTqxRV5b6zC1e
MSx/9m3g122hFpQ21fzai1rXQjPMcVFtuGjo9muktRWVrh8zvBl+ONa2ToWGiLWJ
27v5Qkb9IGU=
=QgYG
-----END PGP SIGNATURE-----

--=-abN6t/cU8Ln/vGpp9sXp--
