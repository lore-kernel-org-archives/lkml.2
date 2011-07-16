Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1GPOFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 10:05:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55710 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab1GPOFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 10:05:42 -0400
Date: Sun, 17 Jul 2011 00:05:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the final tree
 (security-testing tree related)
Message-Id: <20110717000531.d2e8d6269343e10732a8f542@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__17_Jul_2011_00_05_31_+1000_cWtM+Jk6mGKCU=vE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__17_Jul_2011_00_05_31_+1000_cWtM+Jk6mGKCU=vE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/char/tpm/tpm_tis.c: In function 'tpm_tis_resume':
drivers/char/tpm/tpm_tis.c:845:3: error: implicit declaration of function '=
tpm_tis_reenable_interrupts'

Caused by commit 45baa1d1fa39 ("tpm_tis: Re-enable interrupts upon (S3)
resume").

I have just left this error for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__17_Jul_2011_00_05_31_+1000_cWtM+Jk6mGKCU=vE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOIZqrAAoJEDMEi1NhKgbsYZEH/i4h7Qx+pSFMNFK3OrJFU2bA
21Xs5OjpGFuRr2q/w7qfVUiPD2JDKakplM89bUIKejPLkOtF1mCUn7t36EzpeAxs
aweHAL3MmW/eOe+VxovLcqo2gdBXH9H6P/AFLZt8R44dFKtWU5fNuGYuNf2jDzpM
4+IkLUJUrWS4xCazIC7v19ggrM5m8PdHsH2nYQ4eTicUs7kIW5L/bg+gali+TIaM
+sin8Yl+d3SZ5+ePfMUJPAiE0yieF/0IcsWTdbuX8RUkyJBH+bssceAQ5sMTDN14
H9tbfnaLThHHHX9N791BVpxzqVh9aJ8/CcqfnCV3+Ynu+ilGKmGk6i9yRoWjdJY=
=HZFh
-----END PGP SIGNATURE-----

--Signature=_Sun__17_Jul_2011_00_05_31_+1000_cWtM+Jk6mGKCU=vE--
