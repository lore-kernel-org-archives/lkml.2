Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2LLCIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 21:08:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab2LLCIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 21:08:41 -0500
Date: Wed, 12 Dec 2012 13:08:26 +1100
From: NeilBrown <neilb@suse.de>
To: =?UTF-8?Q?Ond=C5=99ej_B=C3=ADlka?= <neleai@seznam.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] AES instead of SHA1 for /dev/urandom
Message-ID: <20121212130826.7940b428@notabene.brown>
In-Reply-To: <20121212020354.GA30879@domone.kolej.mff.cuni.cz>
References: <20121212020354.GA30879@domone.kolej.mff.cuni.cz>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ysHdE7xbkPINaMdELz+V/hR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ysHdE7xbkPINaMdELz+V/hR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Dec 2012 03:03:54 +0100 Ond=C5=99ej B=C3=ADlka <neleai@seznam.cz=
> wrote:

> I consider to speed-up /dev/urandom on recent intel processors by
> using hardware aes. Same for accelerated aes crypto.
>=20
> Would you accept a patch if I wrote it?

Have you read  https://lwn.net/Articles/525459  ?

In particular the paragraph containing:

   A member of the audience asked why the kernel couldn't just do away with
   the existing system and use the HWRNG directly.

Does that answer your question in any way?

NeilBrown


>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/ysHdE7xbkPINaMdELz+V/hR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUMfnGjnsnt1WYoG5AQLNIQ//bikDv5YNHy+mXfl2xve6UWSjrykYJAXv
Ik1obBqVPEeiXkVcc5lYzySXr9Su/5rubj39avqm9krjqF/edcnT/r6BkvnUWqnQ
0bj5FVkrJdAIpjm5Fh9HTK1V81agB9S6dqfXo5ODEqXpiQVsUrJ2AaJyXFjk+88J
h9ynhnjQ8QLgoAXySbSvUOnGB/Ho37EmTykKjVJn/XyVHzKoTpfk8BGMciJgW8T8
VTDkXwmLWi5UXXI0mhzwHuk+GOu3Pa3ZafQMz/gseylWBSCBwQCS5Uyc22CoGOgb
QMKrTQ23rQqPkLCRzngi/blm2/vceewTTnBbvnJzDMRfU8A2FUcpCHZQ8jsLJ18o
kpZuiNZAN3cGwTCaoYS+hN+oGteVhq9Zc9nN42SM5DVbJaR0tLrZV5WM+NDqpJdH
vF2DEdUS7sTr24vH2AHYFY6aN6qf3v6eBDrNvtQ959BsU/PEER89KMhXx/Bj0fce
mOBqNbtb0F1x8E3i/SOB/ZhudijlFwOEmyP3W1Gpqj0Hcgmgk7AFrOm6dqcqYYVV
cYoD3kIcRDltNttZiZhe5bFrb4podORtMMnAinQsG+R7/Qi9bv8tNcFpKv3OT+A1
v5q3xVQ+KIox2YkWFbWT9FgGGypo78yveMPniQNMAzYIqBq9puSWclYRCKHqHirV
/iuXRNU1WvI=
=2A/9
-----END PGP SIGNATURE-----

--Sig_/ysHdE7xbkPINaMdELz+V/hR--
