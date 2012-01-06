Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2AFHlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 02:41:08 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50726 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2AFHlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 02:41:05 -0500
Date: Fri, 6 Jan 2012 18:40:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the kmap_atomic tree with the staging
 tree
Message-Id: <20120106184055.3669727def69e424cd98690d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_18_40_55_+1100_PO+FhLS8yrnOTj74"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_18_40_55_+1100_PO+FhLS8yrnOTj74
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cong,

Today's linux-next merge of the kmap_atomic tree got conflicts in
drivers/net/hyperv/netvsc_drv.c and drivers/net/hyperv/rndis_filter.c
between commit 453263421f88 ("net/hyperv: Remove unnecessary kmap_atomic
in netvsc driver") from the staging tree and commit e91cd643d15d ("hv:
remove the second argument of k[un]map_atomic()") from the kmap_atomic
tree.

The former removed the code modified by the latter, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Jan_2012_18_40_55_+1100_PO+FhLS8yrnOTj74
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBqWHAAoJEECxmPOUX5FEC90P/1BFxuAN8v6HigMJV+VGBsAB
FA83sCAd8Z+bgw7GBtgxM31U+8GNJh/MDtiQLlywLfUA01XegOZ9+b5pLNVc/6ej
pqNPOjkgGkHgCjEHnM2Jq/wVuNjSNQ3g/Q9v+JgO+ZSd0CF5GA4f/fAk7r6V+6nW
8mu6mD8luVh2PHI7+cWQvr2xIg9nkNvvD3h0DbdQ/byTW3V7AC6uFfekkiflTAEV
9agOvHMD25pQ+h/SMeA8vkOmrx51lamhESBJToTW0IaTqQcX9OBk7JYEPSUAegqA
XkvOga4pEjUx7ChGB97DK3S60gGXTXtXhC7xqD9V5C6rVx1zQnqjRkNi8C8hTEo/
nsP0mL5U4S0n1SDZWJfemRXTuPf5Fm9t/fq5FXeYbWRWVSdG/J+1PyH0w4JGcG5G
WkyG1TpwNv3yppoMvGeNpAu1DV/sLH4XP4vx3PAhNIv+BMFLinz96SsHEZ0w8tBm
f0LRmg+sy6lMYPe/EjJPQq7DX+vgtg4a/aiB3NQLpKqca1sqHfTeZdLYD0y3LCR9
UNq2xXj9r4DJ9nPhwyEQ+qdFFnFIIMFMNu/DOVYnW0cmhCQo9IeexeCkg9LdFM33
rfrd5W8U+5bNlZQMJ10KXk6LK5UxyHBBOAfCLYDtwWv7YMw5MazKLfH4Mb2q3ZjR
+MJmWJk687Dsd50zj6lQ
=WPdL
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_18_40_55_+1100_PO+FhLS8yrnOTj74--
