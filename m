Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0HZBCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 21:02:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40322 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab0HZBCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 21:02:38 -0400
Date: Thu, 26 Aug 2010 11:02:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the cifs tree
Message-Id: <20100826110229.931ab5bf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Aug_2010_11_02_29_+1000_AciCO.adYFhdrfXG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Aug_2010_11_02_29_+1000_AciCO.adYFhdrfXG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/cifs/sess.c: In function 'CIFS_SessSetup':
fs/cifs/sess.c:623: warning: unused variable 'ntlmsspblob'

Introduced by commit 9fbc590860e75785bdaf8b83e48fabfe4d4f7d58 ("[CIFS]
Fix ntlmv2 auth with ntlmssp").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Aug_2010_11_02_29_+1000_AciCO.adYFhdrfXG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMdb0lAAoJEDMEi1NhKgbs18kH/15opIEe5erl4cfcnq0ltBZr
P2tWui20d1QUCpswswWOjQmtlrO3er7hTUkXVEQixG75Gj4iRQ7kagDNrb3RzALM
TcnMfM3jvm3fxPw4AuNF5auc+d23phQ1yRmlhWhb+iUdg4PACylJ64657lxOmFTq
BqojFhmHDNyeKppp1fObzlgn776V07/6+b937+qjBzSGzD2F8GakZ4SDJMw0VmY4
82RnFXMIReZbCQ5CukBhQjLF9ylBsHPbL/Hi6YjlxlNguT7tVLBZO02J3IYF4kb6
LVU0la/fYDUbi0rZok2j8JOZvEuX3LEMZmB4Cw8JdU73st81h7YR0TYxQzduWvo=
=o8Se
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Aug_2010_11_02_29_+1000_AciCO.adYFhdrfXG--
