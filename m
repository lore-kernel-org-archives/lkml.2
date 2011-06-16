Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab1FPDjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 23:39:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32815 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab1FPDi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 23:38:57 -0400
Date: Thu, 16 Jun 2011 13:38:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the nfs tree
Message-Id: <20110616133847.1ba62bab.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Jun_2011_13_38_47_+1000_RyVZymghuOao8jum"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Jun_2011_13_38_47_+1000_RyVZymghuOao8jum
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

fs/nfs/pnfs.h:379:13: warning: 'pnfs_pageio_init_read' defined but not used
fs/nfs/pnfs.h:384:13: warning: 'pnfs_pageio_init_write' defined but not used

(lots of times)

Introduced by commit cb679cdd50a8 ("NFS: Cleanup of the nfs_pageio code
in preparation for a pnfs bugfix").  "inline" is missing.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Jun_2011_13_38_47_+1000_RyVZymghuOao8jum
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+XrHAAoJEDMEi1NhKgbsrl0H/0qIi/6NirH2fBOdlCz2hfHc
uXvvVL69/5MBwRLrLY8Cq8XnaQ6TcJjNnh5J0gs85bKdIAASSE3wFKjxNak9ppLq
9iIjcrI0F8X4cH/CmtPutj96TCOgqcl+bpnwMtvGYWOAVv02aGgazP1InLob0FFw
mhe0wwz02hZqOwHpFD2X8CRTGmE1ZsrcFJHLBRRZtSOcaAbhx059cd79jvNYGv/K
4zWZgXIkRHy3sO7qp+nR5Na1cB0QWsZoPtpI46p0tRa2oGXZ+ahko6guTz5XsMtT
mW3B28LWpeBIZQEisZwqy8IgwIXlte14+FMMw+EiSKua8OUAJy2aduC9L6KvHwA=
=dQzD
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Jun_2011_13_38_47_+1000_RyVZymghuOao8jum--
