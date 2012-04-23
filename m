Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2DWG4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:56:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57494 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab2DWG4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:56:38 -0400
Date: Mon, 23 Apr 2012 16:56:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: linux-next: build warning after merge of the security tree
Message-Id: <20120423165630.b412159ec0e5412ba41e0a98@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Apr_2012_16_56_30_+1000_6iZnn_qIkR4fvWAg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Apr_2012_16_56_30_+1000_6iZnn_qIkR4fvWAg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the security tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

security/yama/yama_lsm.c:322:12: warning: 'one' defined but not used [-Wunu=
sed-variable]

Introduced by commit 389da25f93ee ("Yama: add additional ptrace scopes").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Apr_2012_16_56_30_+1000_6iZnn_qIkR4fvWAg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPlP0eAAoJEECxmPOUX5FEHVEP/RVM5CTtNvOWq35Bobu1YK/7
RIgxuLpMpnqdvR0n97RQO8K3lU2jhNyVRySMq/BDYC1Hba/xrfWn7DSoN3h4Eh6X
/+lUEyk2C9LRjqzpa7SoK6FgwW7kvi+T/AsoihCi4XoDDZIME196nX48siD+4c9p
4UPvyA5n7hNBQ0hJyLVYT142JryVZz1mVUifu9R1zJqptmFQNGllQC1kFAoc2aZ4
iD5KpLaecwBbP6RcJ5nE3HUGWZuMfiftCBYgWzzgWHHsvVN7htSabC0rExPGpSn+
Zr5DHFiD160oA0snuTABAPUTuXKGzs4ei3IJlNj57f2EE/hX3pUsr0iWUDYnyk/Y
0VBFmhBDPOtI7Jv8VAr+VW+GuXtjOZGcfnM2DNoEIplO69kFfVM7dw7RlvpmxDX+
1wuFuxMScz15hHtZPRAauPV+NHrRuyBE060Oj4eVt04LNnG3tY+dzIbJ7ty0s81E
8G1028BwwMFhVOf5xj/q43sgAN4D7pWcy/ndoXxlt2+czhoQ+kAjHzvpODhEvigU
HZZLFdPTo/c5NqkXD9C8TBlpm9oEpvDRbwqW00fXM+FDw+Zuk1RxJnKNNW/27cXs
CkQYBvHNPy797nZph87/l2AYqmyf1zdAMui+qNUjLYUJlx2xgiNqIKK3EP87QkIT
wLvoQVibEIORheAdhF1k
=87Gl
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Apr_2012_16_56_30_+1000_6iZnn_qIkR4fvWAg--
