Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1ISGj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 02:39:56 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:45073 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1ISGjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 02:39:54 -0400
Date: Mon, 19 Sep 2011 16:39:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amos Kong <kongjianjun@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: linux-next: manual merge of the trivial tree with the kernel-doc
 tree
Message-Id: <20110919163946.9165592b447bf5b578146f83@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Sep_2011_16_39_46_+1000_+H9DPu6XkZ52IM+g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Sep_2011_16_39_46_+1000_+H9DPu6XkZ52IM+g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
Documentation/PCI/pci.txt between commit b814f0357fbe
("Documentation/PCI/pci.txt: fix a reference doc name") from the
kernel-doc tree and commit c460578a674f ("Documentation: fix broken
references") from the trivial tree.

It looks like the former supercedes the latter, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Sep_2011_16_39_46_+1000_+H9DPu6XkZ52IM+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOduOyAAoJEDMEi1NhKgbsbyMH/0iCWlJSP0Xm5ISJr7sFhbOv
uagqQeT1QgvURCRXmEezDn/wrYX0rDF9NXXdDnDo/Gx2TD+CGRd0ogpwR0KQ9Uqf
3/YQBZAFoWVmojo81bEUlkG4GEzD51hiHctzLjvV0n00S5YuPSMU06cyAf6HkErI
RwYqCtG8VfNVGFOdOKSeWn1rcuLR3dimXUa+H9+lOK1s+KwcCKvDRZ+CAH2xTvyk
x7O4heFLWp3tkUsZtxP9jQ25kFEXepAOyuXhgdE0WktnHIMN03OXx2ZFMvVIlSsY
VByodsu2XpHxtdDDUKAxY/y+eXYEsb6qO+1UVgXA+QSsW3nFLiECZqgJgGvjCLg=
=N59e
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Sep_2011_16_39_46_+1000_+H9DPu6XkZ52IM+g--
