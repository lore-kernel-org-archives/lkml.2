Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab2DYQ4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:56:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab2DYQ4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:56:20 -0400
Date: Wed, 25 Apr 2012 12:56:14 -0400
From: Jeff Layton <jlayton@redhat.com>
To: torvalds@linux-foundation.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: docs: pull request
Message-ID: <20120425125614.712788ba@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6hM+SUMQ2KbC5SVi0aWBgSN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6hM+SUMQ2KbC5SVi0aWBgSN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Ordinarily, I send my patches through others' trees, but David
suggested I just send this one to you directly since it's just a
Documentation/ update:

The following changes since commit af3a3ab2966112c0d0a44df7eeb1e95fe32d4495:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes =
(2012-04-24 08:22:25 -0700)

are available in the git repository at:

  git://git.samba.org/jlayton/linux.git docs-3.4

Jeff Layton (1):
      keys: update the documentation with info about "logon" keys

 Documentation/security/keys.txt |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

Thanks,
--=20
Jeff Layton <jlayton@redhat.com>

--Sig_/6hM+SUMQ2KbC5SVi0aWBgSN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPmCyuAAoJEAAOaEEZVoIVJrQP/RWy2AmRJGVCPlKWKAuiX9CY
ZMkXO9GUJnNU+vyxgRBei4KUcP6fHQzscfbK0lq+W8SZ7OqiR0K28Av2+tcl8bb6
4lIKtBk7isY1/zKY86E+xl6CnPQlMRLa4jvt59GOCp3h8FSJXG4MsdrK7NdmegBh
1ZW/Opb4XEyFhk1Q8PTjZ/cnPBiLYdPHMFm68m9NNiDvh7K0SLauOtsDHgwXHDDf
S0UXy8sTqeKAI9sUPP3mOp5vSVReGeFMpV9PVwsmhcPU82lYGd7xTKKw0EL5CE3B
mhVB6OntRF15UKufg3uyrSV7o1rezT9U4V/9PWf1CfqQLntZYayRnNZ3fxww0w2b
5fVOA6k22RFaMatNFikx5NKIwH8On2R6Ligs/vF+w3EWc+16LncGG53Zr3HFq4Dw
jZHtT9LavnYA/0RNUCfPbZpX/Pd2Wm0O6c4yrjlnrnuHNaJE3aKlAu/wPKLrJ6p9
Y3dpzHETNvQd9UIAMONFVWzba795OaKTIs18RyAvf1/XQvKrZKSngNdYhVfytSwD
rmOYdQ9Drt8pjq/NqorUVKUA5GCd5eTcgUAJWAXtPTwj7EJn4Q3TmBIpfCGeOw6/
QTPs0GxaDJkHoryUym11lgsmzWoUAYCi02B11cUJMjc0JvET2uUfdbn+lObIKbye
tqNJqlyKcWxEHr3OEPIj
=Q1+5
-----END PGP SIGNATURE-----

--Sig_/6hM+SUMQ2KbC5SVi0aWBgSN--
