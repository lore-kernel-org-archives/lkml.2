Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2LLB1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 20:27:14 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:24431 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2LLB1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 20:27:10 -0500
Date: Wed, 12 Dec 2012 02:27:08 +0100
From: Christophe TORDEUX <christophe@tordeux.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Tai-hwa Liang <avatar@sentelic.com>,
        Oskari Saarenmaa <os@ohmu.fi>, Paul Fox <pgf@laptop.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 01/01] Input multitouch: fix horizontal
 two-finger-scrolling on Sentelic touchpads
Message-ID: <20121212012708.GB9043@sherka.no-ip.biz>
References: <20121212012135.GA9043@sherka.no-ip.biz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <20121212012135.GA9043@sherka.no-ip.biz>
X-PGP-Key: http://christophe.tordeux.net/data/pgp/c-tor2/pubkey.asc
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I am very sorry I forgot to mention that my patch was done against=20
kernel version 3.7-rc8. I can re-send the original patch with this=20
information included if required, just ask me.

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQx91sAAoJEE/hdwZK2YytOMkH/3NRjJH16AK/1R5+u+KOIpwL
ZIrHYnQjwRb63j1lQTFM/GtGBSHQ2f1ZCgkZFxIZUQ6JS2h+NFcjcuZtP0th+2nZ
IosWYOkwnzY0ljMAdtlyXHqBXy6naaOLJfKz4SGjpRWDyK1HbxqX6VlpSfC8Tcbg
NoUcRUBbw2rAcKd0cWPcbD8+nGKSIB/72vkwQMTgQYtffDejDG25Itzvb2B5npTK
m1MOW2psUFY3zR51vRC0QAD5kbNzmCKJjh2n+JVMwyg2T6iXqpZW3k02E0qVVxv2
jqN/9/JfkAug+yy5RGMgHYNavQoCCCsnq2gSJ9+p1LTVtV44xNdu7tG99hjJacA=
=HY7V
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
