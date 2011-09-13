Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1IMCLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 22:11:35 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:48453 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1IMCLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 22:11:34 -0400
Date: Tue, 13 Sep 2011 12:11:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the openrisc tree with Linus' tree
Message-Id: <20110913121125.57aff757d1cfe59a117ee3f6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Sep_2011_12_11_25_+1000_WG8ZaGTbomJriE8h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Sep_2011_12_11_25_+1000_WG8ZaGTbomJriE8h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jonas,

Today's linux-next merge of the openrisc tree got a conflict in
arch/openrisc/kernel/signal.c between commit d7cb66670905 ("openrisc:
don't use pt_regs in struct sigcontext") from Linus' tree and commit
ddf54eaa745b ("openrisc: don't use pt_regs in struct sigcontext") from
the openrisc tree.

Two slightly differentl versions of the same change.  I used the version
in Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Sep_2011_12_11_25_+1000_WG8ZaGTbomJriE8h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJObrvNAAoJEDMEi1NhKgbsMRUH/jnbn5LjN69b1q14w5KSzDU7
vkAuAJ0QvU76bXUTT9hHouQlSvxk0slcmNBh/2O7uBG0JweaIkfpkPufgWRM8M5p
GWHtUo1wTrv18B44p1NNnLf/kMsP7uc/UURCfYgqS0hiXL303NU5zRNRAT7jOyuE
mUSZpcN9Cd21NhYKywfj7jsYyfexA/O4ZY29QOL8F2I2BmujEblbe2khvYfLp4+9
euFcc73ggLAS9T1Q0WEGxw+u5cnKFwFhZvcYB00HCVBhdXoB2XRMTrsBq6hyZWaE
Xsawk982aSBNJx2zkEk/xfO+CWb1KpSdsdWm6qI2iYxQkNwnGzN6JQEv4grBRjs=
=bW/r
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Sep_2011_12_11_25_+1000_WG8ZaGTbomJriE8h--
