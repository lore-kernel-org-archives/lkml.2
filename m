Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1GEGpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 02:45:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57280 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab1GEGpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 02:45:02 -0400
Date: Tue, 5 Jul 2011 16:44:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: linux-next: build failure after merge of the final tree (rr tree
 related)
Message-Id: <20110705164455.0325d2db.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Jul_2011_16_44_55_+1000_5XbYYSp9RI1UiaHZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Jul_2011_16_44_55_+1000_5XbYYSp9RI1UiaHZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

kernel/built-in.o: In function `locate_module_kobject':
params.c:(.init.text+0x133a): undefined reference to `module_uevent'
params.c:(.init.text+0x1342): undefined reference to `module_uevent'

Caused by commit 5858ac1e3bff ("module: add /sys/module/<name>/uevent
files").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Jul_2011_16_44_55_+1000_5XbYYSp9RI1UiaHZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOErLnAAoJEDMEi1NhKgbsMG4H/RDs7nJe45ufFwYKwBmGCcLd
ydBv/ImQq4GgUpIDZ9KSXxWL+b5KSyvzL8TjXXfYMoY4x6BAbQAgw9Mh08Y09JVv
labFG0BW/dWNLyJGfhNNAa+3sQQREaQEOb181/KVb5TOQQrTp4N03IPlgMwLqlon
YowhQikH9PS0kSZYAsVBytqz2cvTSfC5YbJi2m8YSpPiiPkvLC8vXk0rgmfNzwZf
bCXncz3QjEY8BZwIPd9KrKgosrfKw8jF3aVdHDCwAEhRy6Phw+hiSMcAqAmKMoiK
rbNdyTrnIKGBRanMS9gMA/vi5ULO82zBVeYG/8Q4EtHVhQX1TAq2ByAeKJWCa4M=
=ygBO
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Jul_2011_16_44_55_+1000_5XbYYSp9RI1UiaHZ--
