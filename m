Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595Ab0E0ExP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:53:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54778 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933514Ab0E0ExN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:53:13 -0400
Date: Thu, 27 May 2010 14:53:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: linux-next: build warning after merge of the kvm tree
Message-Id: <20100527145307.0e6d537c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__27_May_2010_14_53_07_+1000_jcM4bKgzCAsSLPld"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_May_2010_14_53_07_+1000_jcM4bKgzCAsSLPld
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

arch/x86/kvm/svm.c: In function 'svm_handle_mce':
arch/x86/kvm/svm.c:1489: warning: unused variable 'kvm_run'

Introduced by commit 5c91e7b615f7b6b36f6ad32356bb786bed5b7764 ("KVM: SVM:
Implement workaround for Erratum 383").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__27_May_2010_14_53_07_+1000_jcM4bKgzCAsSLPld
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv9+rMACgkQjjKRsyhoI8xq0gCglKcIRMOjOx+CtUXDa0pIYjV/
aVMAn1tZnyDiX6WhLoMAnmZnCjOCI9HP
=bNJ/
-----END PGP SIGNATURE-----

--Signature=_Thu__27_May_2010_14_53_07_+1000_jcM4bKgzCAsSLPld--
