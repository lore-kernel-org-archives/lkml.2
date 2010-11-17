Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107Ab0KQCOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:14:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34760 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933395Ab0KQCOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:14:37 -0500
Date: Wed, 17 Nov 2010 13:14:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: linux-next: build warning after merge of the usb tree
Message-Id: <20101117131427.fd26efd8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Nov_2010_13_14_27_+1100_t299i8qTVpE2GR=C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Nov_2010_13_14_27_+1100_t299i8qTVpE2GR=C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

In file included from drivers/usb/gadget/g_ffs.c:64:
drivers/usb/gadget/f_fs.c:30:1: warning: "pr_fmt" redefined
In file included from include/linux/kernel.h:20,
                 from arch/x86/include/asm/percpu.h:44,
                 from arch/x86/include/asm/current.h:5,
                 from arch/x86/include/asm/processor.h:15,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:7,
                 from include/linux/module.h:9,
                 from drivers/usb/gadget/g_ffs.c:22:
include/linux/printk.h:161:1: warning: this is the location of the previous=
 definition

Introduced by commit d8df0b611c66db3b7afd0678213979209616681a ("usb:
gadget: f_fs: remove custom printk() wrappers").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Nov_2010_13_14_27_+1100_t299i8qTVpE2GR=C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM4zqDAAoJEDMEi1NhKgbs8LEH/1FGp0zHuBDZo5nU69U20Ezo
cUdr+b5OtBak1yuZMLaZbZyYW/a2lvb1tOr48fzD0/RaJOxyGa14C6X2XMzn7OZk
pS4Da8NBB2cqHHCiqLOBvMgDfv9mGAQ6Nb61rDMM7UvOe8MTKyBHBB0r9mEalfbA
kgFDI2HXGOwWz7rYLAexs7Ii8Yixe02BdGEIGJwWZn6jlrGMZZaMyliW3nk6YE+V
yK7QDG5hf4gRNQmflLtCUy3Lp/WmNPhVd5QYieLblkBtIUYrIqhXlvKXpRUH74Hp
mbqjQsm17ztcDSz4w2l+lhM5xDjtyTeLhIMCPakSA9a1abDgp5fT6yDOSnTDOuo=
=ZgtO
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Nov_2010_13_14_27_+1100_t299i8qTVpE2GR=C--
