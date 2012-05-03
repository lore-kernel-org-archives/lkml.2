Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2ECDHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 23:07:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60638 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab2ECDHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 23:07:41 -0400
Date: Thu, 3 May 2012 13:07:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20120503130725.5064b8c0fe9c072a8763d30e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_May_2012_13_07_25_+1000_Mq8fJy0H_P5vaHwU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_May_2012_13_07_25_+1000_Mq8fJy0H_P5vaHwU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit 99d9acdd0c5c
("drm/i915: Do not set "Enable Panel Fitter" on SNB pageflips") from
Linus' tree and (I am not sure which) commits from the drm tree.

I fixed it up (the former patch got applied in completely the wrong place
by git merge).  This file looks like it was massively rewritten in the
drm tree :-(.  I have not included the merge diff because it was >2000
lines.

Dave, as an experiment, you might like to pull that former patch into
your tree and see if that fixes the merge with Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__3_May_2012_13_07_25_+1000_Mq8fJy0H_P5vaHwU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPofZtAAoJEECxmPOUX5FETagP/3M95R1NJJ+3T9M1EnxYDKLT
Go2NDkHU/eJ1DF82T+9isp/AhvI6rlLUsMscCC12ZxF2bq1QJSRJg7X/fkKWsWsP
i9YfbHvFg9so5141u8J0Y5juBAW/VgXkg8l5cctN8+gCrJrUYzbSheUbTbFeY0HT
wvK8dWquzOs/x7K+tiL4RPe8nrpJ+e8cTh2qiWwbKB6Vrx12knIp3cQ7nrGPhn/N
Uo1wrz7gP7ew6liwkZEkRte0iNoIudQdfNC3HeadTPKX6NWdfABrmUEhueN51Kaq
6qDc58XU8xvzcV9P+DJ0nIh1z0P8Z13lPu/rSIBxWh3bPe++jB09vRfHfj/2l+hE
PocaKpDrQBdseOn1sSQSZle+HI+uVPgoZ4bhLnqlpeBA9/FJF8XscCXRkjl8tzgY
vpm7tvMvzTtRkjcV1kS+89ou84squ3fNlHCBQ/HB+vQXbejqbrBGi81abaihJrhh
7TO8EHPzlFh4+oBDPe8Q+lYB4t8TaR+z4I1L1XqhRoJOGLXvqgPrknqskh1sYz7i
kW6sLqRJe7mxMgPYGbp6En1mvjy2fM42RrwMAIqhR3Lt3CQrrefd8o7pn+thJkF3
LjwIqPSFHGVy6Bbww65EBoYM6Cko/ZBk4/IhKPoerKuIOQu/gVKxTyJu+L95IVDb
E7g9C3DFXJKleClHQ+dg
=pNwv
-----END PGP SIGNATURE-----

--Signature=_Thu__3_May_2012_13_07_25_+1000_Mq8fJy0H_P5vaHwU--
