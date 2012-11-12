Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2KLRIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:08:15 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54843 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992Ab2KLRIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:08:12 -0500
X-Sasl-enc: j+nBFyvk4iBYV/XeiS/4k4G7/Mray+N6EL5M3R3A41/6 1352740091
Message-ID: <50A12CF9.7000608@imap.cc>
Date: Mon, 12 Nov 2012 18:08:09 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-kernel@vger.kernel.org, davem@davemloft.net,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] isdn: Make CONFIG_ISDN depend on CONFIG_NETDEVICES
References: <1352282103-13665-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1352282103-13665-1-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB344C93EC3BBAA095A4C37E3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB344C93EC3BBAA095A4C37E3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 07.11.2012 10:55, schrieb Lee Jones:
> It doesn't make much sense to enable ISDN services if you don't
> intend to connect to a network. Therefore insisting that ISDN
> depends on NETDEVICES seems logical.

Well, not quite. ISDN is (was?) also used for telephony applications
which could work just fine without network devices. But I guess not
many kernels will actually be built with CONFIG_NETDEVICES=3Dn, so the
inconvenience is small.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)



--------------enigB344C93EC3BBAA095A4C37E3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlChLPkACgkQMdB4Whm86/lndACfTtpdyYN/SwgtIfYCxV1kF0Qb
LS8AnAufcDUSDIliIjuu4X/MagMpcZJw
=WOqN
-----END PGP SIGNATURE-----

--------------enigB344C93EC3BBAA095A4C37E3--
