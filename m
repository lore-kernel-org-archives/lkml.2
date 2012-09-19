Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2ISFVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 01:21:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43690 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab2ISFVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 01:21:39 -0400
Date: Wed, 19 Sep 2012 15:21:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the signal tree with the sh tree
Message-Id: <20120919152130.dc856a602341c98b6ec93778@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Sep_2012_15_21_30_+1000_N8BTj.=KeHKA_Ttd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Sep_2012_15_21_30_+1000_N8BTj.=KeHKA_Ttd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/sh/kernel/cpu/sh5/entry.S arch/sh/kernel/entry-common.S between
commit 5e071e2b4b82 ("sh: Fix up TIF_NOTIFY_RESUME sans TIF_SIGPENDING
handling") from the sh tree and commit 52b8a6e18bfd ("sh: missing tests
for NOTIFY_RESUME") from the signal tree.

These appear to be the same patches (apart from some trivial bits), so I
used the one from the sh tree and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Sep_2012_15_21_30_+1000_N8BTj.=KeHKA_Ttd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWVZaAAoJEECxmPOUX5FED/kQAIeK5yeWEFDV0xD7H20+1+aU
cOEyoCmihj8aBmLfWyqMwx9AWVL/2ojfQaRQSRCHjpiMfzMv/daqXRMlz+cbHW4L
eC7yQcrdLszz2r8w74HeV9a8hvi/XVtA2A6a7sIsOu0z3puaaa+9M55wjzEKqbnP
All/nnSyeVyIDHaJgEXS0F0OkK/tuGl1WV/80PzUspBZx1TQqW80m2+ICqwQH5bG
wfsNQ4mT5NH0TJtSEnKZleD1TKS3dc8t/+P6+bNB7m9NCFb2Q2sa9nZjEwchIYSb
Br2aR6yrXHHv8MB0TFTkzK5DeJYKTWn+UWhX8z3dfSB6R8GEnWGeyMcEZEgOHtt5
3pX32Oph89ZG93XGxnWN22Rwo9WWwNNsDVW6TBKpGH94WR+FgOd5lXpAd/yxT3PB
hXRSVp079MtIPFdnLu1/1Vmyv2sDtkePRdaqaDHL7MB9AH9w/Z6l89OkEhPs0sCX
0ymX75pkD6Mxnb2v5a2KsBKfb1ckJ/3vwd0hOnYxK1i02dfRuLSmqpDTM3XapPkB
UTxo0S6U6Coraqw3rtx/RsRBX4p2huL992RW9kD1PVTTDWEogCt+sOdZA/cTzSEH
eFVYltAAM3vkqcDLrb8CGML62HrWK4dXjNsyyYRsaavN7HdpDwq5lAugcdWnL6m5
sqEgYkBKKMxrXz7nffBs
=NRqr
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Sep_2012_15_21_30_+1000_N8BTj.=KeHKA_Ttd--
