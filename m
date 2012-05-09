Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2EIWET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:04:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61519 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759763Ab2EIWEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:04:16 -0400
Message-ID: <4FAAE9D9.40707@gmail.com>
Date: Thu, 10 May 2012 00:04:09 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow to create a minix3fs with a blocksize != 1K
References: <4FAAE6EA.3080308@gmail.com> <CAFLxGvzo9JNGdxGqr1nn+aQtq7aiVOqkn+bD7Xn7idvfKo-wrA@mail.gmail.com>
In-Reply-To: <CAFLxGvzo9JNGdxGqr1nn+aQtq7aiVOqkn+bD7Xn7idvfKo-wrA@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig688A595F6A6361D1F751CBBB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig688A595F6A6361D1F751CBBB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09.05.2012 23:57, richard -rw- weinberger wrote:
> On Wed, May 9, 2012 at 11:51 PM, Vladimir '=CF=86-coder/phcoder' Serbin=
enko
> <phcoder@gmail.com> wrote:
>> Have used it to test minixfs support with various block sizes.
>>
> Isn't this patch against disk-utils?
> Why are you sending it to linux-kernel@..?
Yes, I've already noticed this and resent it to the util-linux list.
Do you know if linux-kernel is the right list for my other patches like
wrong minixfs block allocation check or AFFS race condition? It seems
they've all been ignored.
I have few other bugfixes or feature improvements for lesser filesystems
but I don't want to send them unless I feel like the patches are going
to somewhere else than /dev/null.


--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko



--------------enig688A595F6A6361D1F751CBBB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+q6dkACgkQNak7dOguQgmI/wEAv2jxuBT/eUNchFNor1YYDrBo
ee2WZ/i1gUnsnW+LN+gBAISIJo97w/Yrbs9im98cix1XpmQKO4ZSZ8LTz0fd+p1B
=LmB9
-----END PGP SIGNATURE-----

--------------enig688A595F6A6361D1F751CBBB--
