Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980Ab1IKDeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 23:34:22 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58867 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab1IKDeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 23:34:21 -0400
Date: Sun, 11 Sep 2011 13:34:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>
Subject: Re: linux-next: manual merge of the i.MX tree with the arm-soc tree
Message-Id: <20110911133410.a1de21cd74e0af9c9ee51549@canb.auug.org.au>
In-Reply-To: <20110909064058.GF28816@pengutronix.de>
References: <20110909114436.5afc4ef772143d90ce75c7c5@canb.auug.org.au>
	<20110909064058.GF28816@pengutronix.de>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__11_Sep_2011_13_34_10_+1000_R.Z_.YrfgRb8x59g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__11_Sep_2011_13_34_10_+1000_R.Z_.YrfgRb8x59g
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Uwe,

On Fri, 9 Sep 2011 08:40:58 +0200 Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pe=
ngutronix.de> wrote:
>
> Do you prefer that conflicts like these are resolved before you get
> them?
> (I.e. I could have done
>=20
> 	git merge -s ours $somecommitfromthearmsoctree
>=20
> but I wasn't sure that this is a good idea and so decided to wait until
> you write a mail about the conflict.)

No, these small conflicts are not a problem, so just leave them to me and
Arnd or Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__11_Sep_2011_13_34_10_+1000_R.Z_.YrfgRb8x59g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJObCwyAAoJEDMEi1NhKgbs48IH/1HJJLmpEYpPfRBXCfZrXdDV
WPJhwZrZ2CkslZqZx9qYaQmEP2YRZV2bjNOq9ECFsZEVUBs47QKlp8fqjb8PLh2L
dugzpYyOvwZv6tjCdmpo98iudsD97wal8jXpkag+ZtFjUxsK2Y6ezhFA3htdpV8c
/7YogBiBk8RTyngUizXwogOHo2Lh0biHE3+WGYiTxV6sjrOe8AWaGQfC0r9UwkYe
ZJjhkr6xEAjaZ0gf9RLzBT46lDe16bnVh3yjhEXAO3QONo9Ma+D6Ih+gJbQiUzGt
P88z6WhzwHFMGlg43/yn+jZhzLFkH/p/EnqlWMJIYomsBLvUB6Ea+qF2A/AhV/o=
=lcRg
-----END PGP SIGNATURE-----

--Signature=_Sun__11_Sep_2011_13_34_10_+1000_R.Z_.YrfgRb8x59g--
