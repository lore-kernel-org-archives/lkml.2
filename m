Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab1KVDUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 22:20:47 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:55782 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab1KVDUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 22:20:46 -0500
Date: Tue, 22 Nov 2011 14:20:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: linux-next: manual merge of the wireless-next tree with Linus' tree
Message-Id: <20111122142022.ab105e8d6c7b82a0ed8364a7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Nov_2011_14_20_22_+1100_CBs9vXEB9Uel3.S4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Nov_2011_14_20_22_+1100_CBs9vXEB9Uel3.S4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/wireless/iwlegacy/iwl-tx.c
drivers/net/wireless/iwlegacy/iwl-scan.c
drivers/net/wireless/iwlegacy/iwl-rx.c
drivers/net/wireless/iwlegacy/iwl-debugfs.c between commit ee40fa0656a7
("drivers/net: Add export.h to files using EXPORT_SYMBOL/THIS_MODULE")
from Linus' tree and various commits from the wireless-next tree that
renamed/merged these files.

I just removed these files.  Though someone should check to see if the
new files need export.h or module.h.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Nov_2011_14_20_22_+1100_CBs9vXEB9Uel3.S4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOyxT2AAoJEECxmPOUX5FEZX8P/iGb9wV2DiE4lYn4vc4V/szo
bVcfEHwvvxgvHpta4vmdF9QBnvrnMIaXcsikIGe/ibCIzAE1/FfMkeG30Wdw5QdJ
1zoE9/ihI8J3W7SHil+VyJN27htWZmKJ8SAw9AqRer59dFGFwp0YK96CHw5sICdv
+ax8VrEUwIBVuMeNS/JbsbbiOPomDKrAj7ea2uLZQiRmDwj9GTzwmNbUwiYgodmP
zFWR1bHgrim8LstLiXjfEgcILlfN64ZFKCBbqVaONyWloWYkHMFdPDDI3lWQ+B16
6XDgnryKPKH+1SznLiOnDKstRiq9r+YnoUt1qe8S9sKL5z33cxMLM3bnuKNjDLxF
K5ZG2sL3FaRz8ycyqiGbJyr69H3msBUWmIwIF48ZqLGBinhxpBAlegfnUVGzG7c/
KVqyO6/g1dw3/LgM7+XHH/zNSbPeLlS0A4m5MwBrJaPcCVbeU3xqFxumKMHrey82
WPpWZ/7qQ31hGknfT9TxvXPbRyUMUOBNwztX3GwRCV761/Do6n3qM0lzhNVQd3yJ
yLeEl/MvvJ52nbXffvXt+S5mJa+vImaKxeLvKEIn6YhvNimlGDbCZdBjB3uf9gNz
qNEzQJbakfa5LvPrIopWEU31NYKypmPRzLhPlzsSTHHxxk4OEPJGPY00rWjN6fSy
DLZzSMSZOAlmY9df9DsS
=qz7i
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Nov_2011_14_20_22_+1100_CBs9vXEB9Uel3.S4--
