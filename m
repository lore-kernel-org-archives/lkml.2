Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1HJBCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 21:02:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37595 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab1HJBCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 21:02:31 -0400
Date: Wed, 10 Aug 2011 11:02:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: linux-next: build warning after merge of the security-testing tree
Message-Id: <20110810110224.53649ac34b8d5840c7a38691@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Aug_2011_11_02_24_+1000_ifn8U2o+cQW7IWLm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Aug_2011_11_02_24_+1000_ifn8U2o+cQW7IWLm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the security-testing tree, today's linux-next build
(powerpc ppc64_defconfig) produced these warning:

include/linux/evm.h:48:12: warning: 'evm_inode_setattr' defined but not used
include/linux/evm.h:48:12: warning: 'evm_inode_setattr' defined but not used

Introduced by commit 817b54aa45db ("evm: add evm_inode_setattr to prevent
updating an invalid security.evm").  "inline" missing.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Aug_2011_11_02_24_+1000_ifn8U2o+cQW7IWLm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOQdigAAoJEDMEi1NhKgbsy3wH/0rB2drcI+1MUvoZ/twkZY4x
0C5MEZ8jEuqPdqJm7EtFGz8yT20lgOPVSBIV8/oBCn3nMqePH0976YnYkFkGDQgM
Lwrah3aobkN+fSQOBJIjvdUtCLPoDp9kxMVYsWibLirXfrtBPR06pngWfsDByQso
Y2F9Hf0McZYC0NwHFIbbPDL5Y62/EOi21NAHfB6oAc6S4TXmf+6Q7s7Cc0Qa+zEe
D5uhH0Rgflw/OZwAHvHkr0EEq4AUcrC92KXsGtcktTnQcSUnKq0kqrM2TNLgGyoq
CsYfUi04jECn9oS6lASnlTdG7/47hxxaKNq4YoctXn2URWmkUKxIr775OAQvz8w=
=WVrQ
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Aug_2011_11_02_24_+1000_ifn8U2o+cQW7IWLm--
