Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2FLGMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 02:12:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38829 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2FLGMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 02:12:05 -0400
Date: Tue, 12 Jun 2012 03:11:58 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hedberg <johan.hedberg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: linux-next: manual merge of the bluetooth tree with the wireless
 tree
Message-ID: <20120612061158.GH24440@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"Gustavo F. Padovan" <padovan@profusion.mobi>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Johan Hedberg <johan.hedberg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Marcel Holtmann <marcel@holtmann.org>
References: <20120612114701.85f70fd92fc42a9c9f2962ac@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20120612114701.85f70fd92fc42a9c9f2962ac@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

* Stephen Rothwell <sfr@canb.auug.org.au> [2012-06-12 11:47:01 +1000]:

> Hi Gustavo,
>=20
> Today's linux-next merge of the bluetooth tree got a conflict in
> net/bluetooth/hci_event.c between commit 1c2e00418317 ("Bluetooth: Add
> support for encryption key refresh") from the wireless tree and commit
> 6039aa73a132 ("Bluetooth: Remove most of the inline usage") from the
> bluetooth tree.

That is because I just merged bluetooth tree into bluetooth-next, should be
fixed on wireless-next once I do a pull request to John(this is already fix=
ed
in bluetooth-next). Thanks for spotting me this.

	Gustavo

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1t2uAAoJEPs3PUX4s20oNSYP/0+ar71hz/cjD8QXcFBpHeXn
U9TTLb49Sgac/hGwU/PtALqSP44iM/l3FDoqHc1fw73thpiIXMa+eE5mONEDbpnG
1E99tDVSKQ9aykU3LiQ6LtHvEHDwlA2bd7+0K2LybRfSeRr9HiNsH3ZxWgf0mRaS
4NUyZkww30ub1m30B6bPZ9FRbNmU9HxaDiN4lcW7ozYe1rOq0SEAztNVti4kxWyL
ySfk2AcBVfF90D+Yhs1wlOOU7hxhIluHDwIcP2+zLA+u5BspKeYoSFf1CjnulOx8
yTd62zEk/ygADnMzK324P5MbIEBMqq/miHSeDEJl5JQVSKaFWSHK1zNiGr+EzlCD
eMDS8oWtabwBFOx9EHrnL5F9veYG5HL/otQD5nCiKSkX1wUEZHqqt0t5cfJg+0wM
azA6HVOmmogRObk+/Vqkbc+6hIqHbyG0Udxbc+olGk+2eagpfqq/hBodGjtUdxwq
8vUUCrH+MGWgNa6E7xPznOXvmbfLD4SRa/RsrzdPqRrAiDG/0v5UZ65tBI2uKZUF
l/VBMdLvgNGMjmqRQ0A4PXXQxqYjABVHzywh1vWE6F/yHhtHQAKByIN3LRkL0pRt
A0cwZuDCous/2JaV6Ob+tkTlHBRPbZrkpaXvyt5hIdboCkNJvABTzsOJJ/qaz6P9
lGYvBKCgq11XVzn2WRxh
=OMQX
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
