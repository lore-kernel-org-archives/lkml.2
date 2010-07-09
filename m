Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0GIBEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 21:04:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41500 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab0GIBEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 21:04:34 -0400
Date: Fri, 9 Jul 2010 11:04:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ben Hutchings <ben@decadent.org.uk>
Subject: linux-next: build failure after merge of the infiniband tree
Message-Id: <20100709110427.c05987cc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Jul_2010_11_04_27_+1000_5WCz/VCZhfwrMdic"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Jul_2010_11_04_27_+1000_5WCz/VCZhfwrMdic
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the infiniband tree, today's linux-next build (x86_64
allmodconfig) failed like this:

make[2]: *** No rule to make target `firmware/qlogic/sd7220.fw', needed by =
`__fw_modbuild'.  Stop.

Probably caused by commit bd4d621eacaa6455da1c23260909da89ef4c1a01
("IB/qib: Use request_firmware() to load SD7220 firmware").

I have used the version of the infiniband tree from next-20100708 for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Jul_2010_11_04_27_+1000_5WCz/VCZhfwrMdic
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMNnWbAAoJEDMEi1NhKgbsTfwH/RiyT0e72A4h23qRP5BjJVBk
NN2R9018JEYAbas872hAopNuX0Q+bIKulzOiZ/eUMAg/Zr7xqdYMLbB/h8uDaQ+r
ydPs+Ee7N2FB/+GKHqTIEDwoGjYBsyQZd3qVn0tMlcND0tpYA/wjm9rM4pyQHGYO
2t9X5RsQTcXfUz2Iou2NwCEGe1cQ1f5UUnX8M5sZrqJm9mUwz/vhaPNVtKTDZxi1
epXoMx/APp9yNsnYmwIvdNk/Vv225zDxP31sWwBGNuHGRB0lwSxH/yUnBNtdqY+v
Gb97PluANOHb1NSyJDH4CvvOM90lBv2lwnBAJzxfeH+/acr2LcAs7GzPON/Tlgw=
=FTkA
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Jul_2010_11_04_27_+1000_5WCz/VCZhfwrMdic--
