Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0HMXZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 19:25:48 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39987 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754361Ab0HMXZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 19:25:47 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX18hDuhKbD0hskgHSLqOaGdOMcmEYc7f9TWvvJN58P
	hSpJU+jSutYAUU
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: Vasiliy Kulikov <segooon@gmail.com>
Subject: Re: batman-adv: design suggestions
Date: Sat, 14 Aug 2010 01:25:45 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-1-amd64; KDE/4.4.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20100809203403.GA16183@albatros> <20100813181833.GA5632@albatros>
In-Reply-To: <20100813181833.GA5632@albatros>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1541659.N9R8iTlnS8";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201008140125.47179.sven.eckelmann@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1541659.N9R8iTlnS8
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Vasiliy Kulikov wrote:
> On Tue, Aug 10, 2010 at 00:34 +0400, Vasiliy Kulikov wrote:
> > 2) It seems to me that NF_HOOK() at hard-interface.c:458 is misused:
> >     ...
> > =09
> > 	ret =3D NF_HOOK(PF_BRIDGE, NF_BR_LOCAL_IN, skb, dev, NULL,
> > =09
> > 		      batman_skb_recv_finish);
> > =09
> > 	if (ret !=3D 1)
> > =09
> > 		goto err_out;
> > =09
> > 	/* packet should hold at least type and version */
> > 	if (unlikely(skb_headlen(skb) < 2))
> > =09
> > 		goto err_free;
> > =09
> > 	/* expect a valid ethernet header here. */
> > 	if (unlikely(skb->mac_len !=3D sizeof(struct ethhdr)
> > =09
> > 				|| !skb_mac_header(skb)))
> > 	=09
> > 		goto err_free;
> > 	=09
> >     ...
> >    =20
> >     static int batman_skb_recv_finish(struct sk_buff *skb)
> >     {
> >    =20
> >         return NF_ACCEPT;
> >    =20
> >     }
> >  =20
> >   As I understand, if there is any hook that returns NF_STOLEN, then skb
> >   is leaked.
>=20
[...]

> b) Why do you use bridge tables at all? This layer does not know
> anything about batman layer, only ethernet that is only a tunnel for
> batman. So, it is able to hook traffic from concrete prev-hop routers,
> but not from original sources of packets. I think it is not enough for
> network filter.
>    Also if you want to process [*] cases you have to append fake
> ethernet headers before network header as NF_HOOK() would use ethernet
> header.

Because a different person (no one from the actual development team) wanted=
 to=20
have it for testing purposes. Maybe we just drop it again.

thanks,
	Sven

--nextPart1541659.N9R8iTlnS8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJMZdR6AAoJEF2HCgfBJntGTw0P/3qmDuPgC0JPKVayqHWtT8Di
ArrHTrBnk1qCUXKNysAdjENG7a0pcFcgjAJoD5tFJn3YPXTwjJKu56cdE1iXaiGW
CyNqbIDaF2a4fdyMJB4DqPkZj1G5mgKK3f//cSTWQGhP3lfVU9mhbGXeyWoZba4D
wfdNWayK9Cw37OnK1/q3Lx1ppZr+KJ/pLN3jR5dyopwy0vk5E/C9oedOxqnHSR9x
hgyNp1gnXujtwkAsG6qH12lLV9ivfbp5wxJlkzv1p4N5pMtFaCDnpfe4NVyIoa3U
XQdilDXoOpP41JFmzhzetnsy1JyPkd5+AuQPHDNjw6giRlcrUmE1qsR00NHjew2h
+s263pJDg3l+lkioy3ppPD/ux4WSoJTsO6pr4QMCPmKDGcCXI/b2dyTkeVgD8GIW
0Mtyo3l2N2LAmLcXLSYo9A0jvadrQDWgTreNa4Ox4ROeTpRwLCaax0acIx+urGxi
GZhSkXlVkYXsjNPEgRlf1MUjAzogPGG3hDaZvFDujmJuSsvmy2WRNpLH9fAqe4k4
OuuwMDWMLD3seTNiDn6LRTuLb8xUzuK94XWrsQf0PoHMEqeZKGwgSJ5olJp3A1Te
f9zSzGuTb2dC5Bocz0JeHSM6mavlSTB88Pb8c3dDfmDevacHYcdiSGXi/dZH7xED
haYTXzWdVWl5tGaIVhWx
=IGL0
-----END PGP SIGNATURE-----

--nextPart1541659.N9R8iTlnS8--
