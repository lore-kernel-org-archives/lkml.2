Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab0IBDSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:18:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51631 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab0IBDSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:18:42 -0400
Date: Thu, 2 Sep 2010 13:18:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>, Jason Baron <jbaron@redhat.com>
Subject: linux-next: build warning after merge of the driver-core tree
Message-Id: <20100902131835.6a8f8c83.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Sep_2010_13_18_35_+1000_y4nqs+kTud8lj1qA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Sep_2010_13_18_35_+1000_y4nqs+kTud8lj1qA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

kernel/params.c: In function 'parse_args':
kernel/params.c:200: warning: passing argument 2 of 'snprintf' makes intege=
r from pointer without a cast
include/linux/kernel.h:203: note: expected 'size_t' but argument is of type=
 'char *'

Caused by commit d1aa8e2ab38942b21d543611d4f829597d8791d4 ("Dynamic
Debug: Introduce global fake module param module.ddebug").

Some warnings should not be ignored ... and it does make me wonder how
much testing this has had ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__2_Sep_2010_13_18_35_+1000_y4nqs+kTud8lj1qA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMfxeLAAoJEDMEi1NhKgbsydAH/RRbkhOIG+8he83WmZ7/EGby
5I3R9VlkDe8l2V6DIp62CfP2Vjh/FhhEMPKe23yP+o56iu0wQWRV1/qa9dU6rR9U
l4uMmuSCP/o6000GPnZ3VQ+1f00HlAa/F+XzXw6hiwxYEF1/nDmCF21a7ZsvHcsT
LIXQzt3fiE5jbZ4+brDM+FmlNz16RPQ+l/+u760JNBTkERVXdtbUo9EPAStjz7jO
l+bA2ctPHZ1UoyiI6Qp6PEGcJZoUIFdfaGtqJ70VAnOTtMr6I543R9jxryZ/rTy2
HeZSL/bfx0hQdM/Xc4aeM2Jp9EThqVP6A1GAcFu7/x3S55BPU/YBjVimpRGAtoM=
=1fwQ
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Sep_2010_13_18_35_+1000_y4nqs+kTud8lj1qA--
