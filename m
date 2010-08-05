Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab0HEBri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 21:47:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44936 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759277Ab0HEBre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 21:47:34 -0400
Date: Thu, 5 Aug 2010 11:47:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20100805114725.7e46da74.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__5_Aug_2010_11_47_25_+1000_tzjg+SIWL8VjQrGQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Aug_2010_11_47_25_+1000_tzjg+SIWL8VjQrGQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

usr/include/linux/fs.h:11: included file 'linux/blk_types.h' is not exported

Caused by commit 9d3dbbcd9a84518ff5e32ffe671d06a48cf84fd9 ("bio, fs:
separate out bio_types.h and define READ/WRITE constants in terms of
BIO_RW_* flags").

I used the block tree from next-20100804 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Aug_2010_11_47_25_+1000_tzjg+SIWL8VjQrGQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMWhgtAAoJEDMEi1NhKgbsFMQH/15JmPxZYfw79Ytc74XS6474
+BMABvnr+wiK1dIW2FK12Ax0IvsUrO4gIUR06toLJGMzylU2EkQnMnG4Y5zGDW7P
u5p6an22JhVLtLXFt3fLbu0wxW14N7Jpwu/8bw4lWZZqp4TqQbKRwz0IPAa/Q+nk
Wy2pIYMr61J7XD/gDUB0HZ1lMPPXrDsup3lyaFZBSZlzrwm9916bVfed+pfH60Vx
YyZ/erRILvUr1eLRUV4aeaeWD8WA8zY1iAmWkeAHtF6oyAenz8TKkgNH9d5dQvxs
4ykg1sypp1+0eoDYqkxPNgwBi+mMoCzxOjv4Rq933Pbqzpccu561eymgWEVgD0A=
=FVtf
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Aug_2010_11_47_25_+1000_tzjg+SIWL8VjQrGQ--
