Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1GGA6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:58:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55438 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab1GGA6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:58:32 -0400
Date: Thu, 7 Jul 2011 10:58:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ram Pai <linuxram@us.ibm.com>
Subject: linux-next: build failure after merge of the pci-current tree
Message-Id: <20110707105823.43343d2f9446f994f97cfd65@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Jul_2011_10_58_23_+1000_x5Q_X/PhNtxDpwfL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Jul_2011_10_58_23_+1000_x5Q_X/PhNtxDpwfL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

After merging the pci-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/built-in.o:(.toc1+0xb98): undefined reference to `pci_realloc'

Caused by commit 72007d2b4797 ("PCI: conditional resource-reallocation
through kernel parameter pci=3Drealloc").

I have used the pci-current tree from next-20110706 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Jul_2011_10_58_23_+1000_x5Q_X/PhNtxDpwfL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOFQSvAAoJEDMEi1NhKgbsiocH/iPIXqvSwP/vax8uI5OFTXQC
GEsL+i+OWkuarW6ApsPm9APEMWv48ZxXfPDf3YYsLTc6DAX/G2MHsPF8c+9ZOmwt
WLhUSkutNkEqKrIgstojTBC0IiM938IuiESv44thL/LbJJA4bRJDmsSWBPD05d3R
lZNmLIv4hvTKSNXDxj7KO2RuQKXW0C6+5g00+sgRX2It6M1F7g09rIKSJZs+HtOn
ww0HOEKMTWxS8ivk0PxzoAmeMQg2C9MGijWOvIY5x6NZJECHJ/m/SJ9L94ymWQqc
sI7hd0Kivxr//+VwvgfQsylSEaeG1T81fabWIy5jUGEC4Zl3wmavfDQzza93JDQ=
=VSP6
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Jul_2011_10_58_23_+1000_x5Q_X/PhNtxDpwfL--
