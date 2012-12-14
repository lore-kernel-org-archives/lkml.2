Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab2LNAGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:06:50 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57465 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab2LNAGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:06:49 -0500
Date: Fri, 14 Dec 2012 11:06:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Zankel <chris@zankel.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the xtensa tree with Linus' tree
Message-Id: <20121214110639.15cc0e084c3291527dfba13b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Dec_2012_11_06_39_+1100_m3gmlEkIA/hxYxdq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Dec_2012_11_06_39_+1100_m3gmlEkIA/hxYxdq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the xtensa tree got a conflict in
arch/xtensa/kernel/process.c between commit 3e41f9ba611c ("xtensa: switch
to generic clone()") from Linus' tree and commit 8daa277ae436 ("xtensa:
clean up files to make them code-style compliant") from the xtensa tree.

The former removes the function that is fixed up by the latter, so I just
removed it and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__14_Dec_2012_11_06_39_+1100_m3gmlEkIA/hxYxdq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQym2PAAoJEECxmPOUX5FEOEoP/RtVGmo3IFGzw83dxWqRqT4E
u5u459zqomduB8SxXnlmt0dNy2k+rdCE3SYjZ4Q2/4KReGCgJV8/r+wRcUyHhPd5
8FBRHW8DHQHo9kxqxn0RA0CggBB72Cx5S+VBRraOPo6Ih3F63HjyUqRQtse8c0Cv
s1sXkhatbcuRJGTU9XItKAw0Kt0gjlOyBxA5lH24VMjPOxB37qXXKGRLV1pP19SS
u6QzgliVHmUAW3etXOPVI6etLdy7nH04CPKrLVHMdbBxDLIsZmnB8sQ1rM1py55D
IU8qoWL3kczfRLQ5UvsoYxbeWv1OROaUON08F61L7PVCMnLYzgJ+snQ0G8DorJ7D
C7s91iHc9/XZaVwT0ZARb8VNgS7i/GaS2qd9ey1U8zpeWS3ccNRPCLH8tojqbdtE
FDZ/Z51yWmc3EFY2E7DswUqahTdLmW8E9qlyusBkhToc05Qz+2zLimPIhHXKm3fi
EOL9u+ufY7pBNPw7chQOgUOQTzpZ5ZNPsUhmH1anGULUllBOUW5IGV9pVm/tSltW
XH04jOAuthSvvyuaEg41aETA5RK79qHEkAtqYPE/6U4yjXwuMSZG/4FddLt+ICYA
UwHHj+MBAriuIRaHTrVM2JeXAG99+d5iJUctDZJssp8lnXp9AvEScphqGYMi52Dq
+EpYP6Poju3AsNdBtNOw
=wvHi
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Dec_2012_11_06_39_+1100_m3gmlEkIA/hxYxdq--
