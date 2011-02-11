Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab1BKM7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:59:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52938 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1BKM7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:59:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=uaAAhJmIbSQm0iEVbobaE7j3aGTCT/N6C/73eLxEGuq097yZVheVjWZPUn7iJoupdb
         0NaSTcn2peMMqeVJKUbzoZGR6SSMCLX3fbZxbrnZ5lJNhKaKJrovKkzkyuz3Z8XK6V78
         uB1eRKIj2kS0iFxYdWPRFzCfLbwwYz7COiXXc=
Date: Fri, 11 Feb 2011 14:59:41 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: revert: loop: queue_lock NULL pointer derefence in blk_throtl_exit V1
Message-ID: <20110211125941.GA4271@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Jens, Andrew

We have accidentally commit "loop: queue_lock NULL pointer=20
derefence in blk_throtl_exit V1" applied: ee71a968672a9951aee6014c555110075=
96425bc

It's not a huge problem, but I think, it's better to have V3 applied=20
https://lkml.org/lkml/2011/1/21/158

since V3 targets all the throttle users, not only loop (by moving=20
`fall-back' from loop_free to blk_release_queue).

V3 is in Andrew's mmotm as for now=20
loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit-v3.patch

Could we please revert ee71a968672a9951aee6014c55511007596425bc when=20
loop-queue_lock-null-pointer-derefence-in-blk_throtl_exit-v3 will land=20
in the kernel?

Sorry.

Thanks in advance,

        Sergey

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk1VMr0ACgkQfKHnntdSXjTUsgP/SrMQ9Jsaz1gnWjWR9Anz/Sni
PsDdVl8PAFXx7st43B4GweTsYS25iIMvuXdUeHIN+Dm7g59sT7L3btPxYIlqkqAA
c8T6KkbrIkpw/NIfVKNu2ybUm4KjWIq11S/Typ3smGo8dNsdBLjcnTTIPaI9Webs
627/ICBuTs+oNItQDQQ=
=3xdd
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
