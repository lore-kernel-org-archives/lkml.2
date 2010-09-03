Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab0ICBcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:32:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55958 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab0ICBcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:32:23 -0400
Date: Fri, 3 Sep 2010 11:32:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Graf <agraf@suse.de>
Subject: linux-next: build failure after merge of the final tree (kvm tree
 related)
Message-Id: <20100903113216.08db65c0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Sep_2010_11_32_16_+1000_JWP.yg_fR.wzGki4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Sep_2010_11_32_16_+1000_JWP.yg_fR.wzGki4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, the next-20100831 (and later) build
(powerpc allmodconfig) failed like this:

include/asm/kvm_para.h:24: included file 'linux/of.h' is not exported

Caused by commit 6e13db5991fea393973f284ec3e951ae8ac3795c ("KVM: PPC:
Implement hypervisor interface").  The include of linux/of.h needs to be
protected by __KERNEL__ .

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Sep_2010_11_32_16_+1000_JWP.yg_fR.wzGki4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMgFAgAAoJEDMEi1NhKgbsKYQIAJX+RmfUIqV9qYPuU552R1BE
SGkNkE6LuuUkTShwkW9AbqU2y9z+23sspfMPBQ0MlzONYQSlik1N0R6El4jYQBNH
FwQTUD1FACEYa4JNUV3KU1D6COxZrIbttqoTtch5lgjLeiglqzm8oBHwngAbl1PZ
h2/w96+tam0jhd9kropNVlmP7QVnO0QzxbrWfb7H0RXL32aEb7F7uNf9g1TLHTqa
COHFApSa6wyLoZe6292Qzsj8WrWRITAFgm9adKDW6NnlmUdNcOq9J+4S8P+wWSJA
E18wfSICVU12p8gz16bgOhbvK1/jOWhH2GNPD6GHOW0zW/zLInUxpMO14hkxmk4=
=erbf
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Sep_2010_11_32_16_+1000_JWP.yg_fR.wzGki4--
