Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab2ENEI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 00:08:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59225 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2ENEI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 00:08:28 -0400
Date: Mon, 14 May 2012 14:08:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20120514140819.e3fe76a21f0c6a7292485586@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_14_08_19_+1000_0yI9E7/8oqpQhAPY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_14_08_19_+1000_0yI9E7/8oqpQhAPY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_ringbuffer.c between commit 2e7a44814d80
("drm/i915: Do no set Stencil Cache eviction LRA w/a on gen7+") from
Linus' tree and commit 6b26c86d6157 ("drm/i915: create macros to handle
masked bits") from the drm tree.

I used the drm tree version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__14_May_2012_14_08_19_+1000_0yI9E7/8oqpQhAPY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsIUzAAoJEECxmPOUX5FEnyQP/2H2rDK60X8vBCSY0z3o/oyI
+fgi8v0iZdRbWPbwxdXbfjcdy/6br2hpapK3n7DPRuhD0yPYzDz+XqzUBA91NIt2
Ueml6Unga/o9XmoUw2gcEO8JfB1XRjmZdTHyIJDrjHidYr/yWt8juXyikz4/N2o6
pWTx9WoN5cjb8bS8yGn8PW0XxNb79ZhuHj+5QkU3HDSrz0TUyHlMf1aotRJtGttx
tq5WsR9P438qB4FL2qTrkfj4HEdMaY5YcXSuRr8oiDJI/TaQ0172cOwH28ui6bFw
1npGVe/BJrepeqChSWqez4qPul5tatXtfQoxtow5xfAWApMZXnC4Lan0D0Z7Vy4L
GgtBS7r/VvGShonNCbMpDP8rHZlknbP3+RI52HJ6nmB2GBkol3i3GKaMg23GjZnP
zqtespB1deGeSpXdk8cxmi6xgtqD1y6ZTm3+MBmMI4vrQGQbVvx4VIIM/l8pMCz0
O107U8znPETj+zahnCXrDyBa3cVC/1MJnCBO33gQcMgqcfrUiRW189DKftvMLT9O
N2F0uTq1TLeLwDgUvRZT4uXLNUNo3+9UXZf9M0dlosABNPKq4srt70IQlX8+Z2B/
a96CqyQzqOV73rPxSRAKvACimOPbARTqPh0OA7UUbiXKwsnZ2WG+TIwIkY9yPsld
yHqy5g7vyGIfu20nvJDb
=5IMm
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_14_08_19_+1000_0yI9E7/8oqpQhAPY--
