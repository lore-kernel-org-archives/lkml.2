Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383Ab2ELAGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:06:52 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43160 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757972Ab2ELAGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:06:50 -0400
Message-ID: <4FADA984.3050901@gmail.com>
Date: Sat, 12 May 2012 02:06:28 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix race condition in AFFS
References: <4FA99001.8080800@gmail.com> <20120510142300.GB4343@quack.suse.cz>
In-Reply-To: <20120510142300.GB4343@quack.suse.cz>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig9AF8BDECBD62991A53A9617B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9AF8BDECBD62991A53A9617B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


>  Otherwise your patch looks fine.

Ok, I've fixed trhe problems you mentioned, now need to test it and so
need to free few GiBs to compile Linux first. Wil send new version ASAP


--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko



--------------enig9AF8BDECBD62991A53A9617B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+tqYwACgkQNak7dOguQgnD2AD/UhAsoMQZwhiYPmmJy9AC2hHy
ga8Ru3kufTJ4w4QXDOYA/AnqZufOlRfgoRDpN257/f0aDWAH1dy9r1oh3QRwX5AY
=2iU7
-----END PGP SIGNATURE-----

--------------enig9AF8BDECBD62991A53A9617B--
