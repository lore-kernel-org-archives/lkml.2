Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1L1C62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 21:58:28 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50463 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1L1C60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 21:58:26 -0500
Date: Wed, 28 Dec 2011 13:58:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the rr tree
Message-Id: <20111228135817.5b92debf636e1fd1c0c68310@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_13_58_17_+1100_pdsiUgmjKEYVINjj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_13_58_17_+1100_pdsiUgmjKEYVINjj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the rr tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

security/apparmor/lsm.c: In function '__check_debug':
security/apparmor/lsm.c:712:1: warning: return from incompatible pointer ty=
pe [enabled by default]
security/apparmor/lsm.c: In function '__check_audit_header':
security/apparmor/lsm.c:724:1: warning: return from incompatible pointer ty=
pe [enabled by default]
security/apparmor/lsm.c: In function '__check_lock_policy':
security/apparmor/lsm.c:732:1: warning: return from incompatible pointer ty=
pe [enabled by default]
security/apparmor/lsm.c: In function '__check_logsyscall':
security/apparmor/lsm.c:736:1: warning: return from incompatible pointer ty=
pe [enabled by default]
security/apparmor/lsm.c: In function '__check_paranoid_load':
security/apparmor/lsm.c:747:1: warning: return from incompatible pointer ty=
pe [enabled by default]
security/apparmor/lsm.c: In function '__check_enabled':
security/apparmor/lsm.c:751:1: warning: return from incompatible pointer ty=
pe [enabled by default]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_13_58_17_+1100_pdsiUgmjKEYVINjj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+oXJAAoJEECxmPOUX5FEo7UQAJGctFGew3BpSnYMdVV13XCU
v3sNuSakbBRXnVs7ldZdP4Pwx3H0RRbkByxkpOTUn9yaFEbx+IYt/RIZgJzrhk1y
GTZpVjMBlW4+SssvUo0abJMmvI9eHdpFb6s3AuTSCfv2JFOqu9M4LdPRdiBeM0Oz
rb+28K+QEVpGA7MfVIDgZfS0jeYa7R1TFB/m70uZSM/pELDRzzEf5d3JxK1QnAJV
4XBVhB8BQMxmZ9Nrd2kT2T3J60+qOrmrzWUeYBNp94+PGDRlvH8Riow4uJumh+Ar
1/9QQVJszcMZOkBfxrOi7Q6+1YHBtogK6fPxkT16L9wIRcxzyTSI6PNnZZJgVk54
79OU9k7trzcst6XZlRai/slIZxtI4cyoP6iGIu4Tydfntfn2Eo96zTyAXPrfsG+K
3wtxXVRfl1J0S7d3zcbm4kkr0icrEULXnUftkC4TVSGjp8J6kWc9tUGhoguiQFq7
6F6oRdoY/G5UX9VTox3O3M+Ff7bZaWUgofrwwJvioaV9izgmjOCrSBxKr4fjLTzL
2zztBGQCLvn1nfefoe5OnuvhAtRVGulQ+7Qpi7jrRoP40YR989CefAkkUw7PCpoQ
V5pKZjzcSuoGPja+g26uBJUBI81t4fKQD7kwS3o2kMvpmuY8iAkHKQlDxDBUejSS
tbZqmpbs6Tna4uOkQtzl
=Ce5M
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_13_58_17_+1100_pdsiUgmjKEYVINjj--
