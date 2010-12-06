Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab0LFXd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:33:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54570 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab0LFXdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 18:33:55 -0500
Date: Tue, 7 Dec 2010 10:33:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: unsigned commits
Message-Id: <20101207103346.fbbcf099.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Dec_2010_10_33_46_+1100_AaW3B.DAlxIeuQ+c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Dec_2010_10_33_46_+1100_AaW3B.DAlxIeuQ+c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

Looking through the drivers-x86 tree update for linux-next today, I found
a few commits that have no signed-off-by line ...

8f2e88b22a4caaebcc8d5a9e00a8249fec350cf3	"Generic key reporting"
e3a2b10707902bcf95d022a5bab8f13b26bccc64	"ACPI-ify"
52f4e59f269e0d3bb1d54ca654d9cbf6880e7370	"Fix some tos1900 devices"
64ea4efdd949c99d9206a44a43984d2e861350f1	"wwan rfkill stubs"

And I think those commit messages could do with some elaboration as well.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Dec_2010_10_33_46_+1100_AaW3B.DAlxIeuQ+c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM/XLaAAoJEDMEi1NhKgbsLpYH/2UU8gmUW7/+8xMyjeWb5JK7
5m9Jl66uQjJSAchke1+j56j/kqtEZSPsM4Ghkaag64FUorggT0Xm7IUDHdJjpQsg
TUtZgX4qsVhAF52455fbXRumSmWm95hnqp497N5sHp5vTOvjgsQr7NSd3IGOmzNW
5L9YJ1lCElOurBD9HA88WDiHM7rWqzKaAVZ6In9S/TwWMQhGv92qgqZ7hpiNfGBf
5npcZpL+GnLTtYhMiFZd3Cle/EsRbDdNPzg+Y0UpzQuv1wWkptApOb3BLgE6HgLj
597JBbPjr09SWiyta12nqenrpjlkk0+IB8u6gtcT8CEQv+JHLWMF+y+AN9VRqDA=
=HVvz
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Dec_2010_10_33_46_+1100_AaW3B.DAlxIeuQ+c--
