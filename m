Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab2EIWUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:20:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50328 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab2EIWUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:20:50 -0400
Message-ID: <4FAAEDB3.5060104@gmail.com>
Date: Thu, 10 May 2012 00:20:35 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow to create a minix3fs with a blocksize != 1K
References: <4FAAE6EA.3080308@gmail.com> <CAFLxGvzo9JNGdxGqr1nn+aQtq7aiVOqkn+bD7Xn7idvfKo-wrA@mail.gmail.com> <4FAAE9D9.40707@gmail.com> <CAFLxGvxAd9HFJuG_GdkzZvfSp1EBNcg1S4v6O3dNpRMKRX45Rw@mail.gmail.com>
In-Reply-To: <CAFLxGvxAd9HFJuG_GdkzZvfSp1EBNcg1S4v6O3dNpRMKRX45Rw@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigB2B616AA3BCEA6F4F11842CD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB2B616AA3BCEA6F4F11842CD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10.05.2012 00:08, richard -rw- weinberger wrote:
> On Thu, May 10, 2012 at 12:04 AM, Vladimir '=CF=86-coder/phcoder'
> Serbinenko <phcoder@gmail.com> wrote:
>> Yes, I've already noticed this and resent it to the util-linux list.
>> Do you know if linux-kernel is the right list for my other patches lik=
e
>> wrong minixfs block allocation check or AFFS race condition? It seems
>> they've all been ignored.
> Not really.
> At least send them to linux-fsdevel too.
Done
> Please read MAINTAINERS and Documentation/SubmittingPatches and
> use checkpatch.pl/get_maintainer.pl.
get_maintainer pointed to this list for minix and ufs (output at the end
of message). And for UFS the maintainer e-mail is likely to be abandoned
(mail.ru e-mails were popular in 90's but are mostly abandoned now). If
noone answers the patches on linux-fsdevel I'll try CC maintainers direct=
ly.
Will read files when time permits.
Thank you very much for the info.

$ ./scripts/get_maintainer.pl -f fs/ufs/
Evgeniy Dushistov <dushistov@mail.ru> (maintainer:UFS FILESYSTEM)
linux-kernel@vger.kernel.org (open list)
$ ./scripts/get_maintainer.pl -f fs/affs/
Al Viro <viro@zeniv.linux.org.uk> (commit_signer:9/11=3D82%)
Sage Weil <sage@newdream.net> (commit_signer:3/11=3D27%)
Christoph Hellwig <hch@lst.de> (commit_signer:3/11=3D27%)
Miklos Szeredi <mszeredi@suse.cz> (commit_signer:2/11=3D18%)
Josef Bacik <josef@redhat.com> (commit_signer:1/11=3D9%)
linux-fsdevel@vger.kernel.org (open list:AFFS FILE SYSTEM)
linux-kernel@vger.kernel.org (open list)
$ ./scripts/get_maintainer.pl -f fs/minix/
Al Viro <viro@zeniv.linux.org.uk> (commit_signer:14/16=3D88%)
Sage Weil <sage@newdream.net> (commit_signer:3/16=3D19%)
Christoph Hellwig <hch@lst.de> (commit_signer:3/16=3D19%)
Josh Boyer <jwboyer@redhat.com> (commit_signer:2/16=3D12%)
Miklos Szeredi <mszeredi@suse.cz> (commit_signer:1/16=3D6%)
linux-kernel@vger.kernel.org (open list)



--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko



--------------enigB2B616AA3BCEA6F4F11842CD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+q7bMACgkQNak7dOguQgm+JQD/RIVKHeRvvzHgkoHv3TC9BT/z
M0ECUG4T2ME/1CmhvcQBAK6PJTcrUM332aiUW2onnHi1poeKLJthnx4ElhWLE/zj
=2giD
-----END PGP SIGNATURE-----

--------------enigB2B616AA3BCEA6F4F11842CD--
