Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2F2DbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 23:31:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38926 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2F2DbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 23:31:01 -0400
Date: Fri, 29 Jun 2012 13:30:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20120629133046.f6c65d4d6017d2ae486cfd2b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Jun_2012_13_30_46_+1000_iJ1qK3BsjEMNcDQj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jun_2012_13_30_46_+1000_iJ1qK3BsjEMNcDQj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_display.c between commit 7aa1e7f06d6e ("Revert
"drm/i915: allow PCH PWM override on IVB"") from Linus' tree and commit
7cf416014813 ("drm/i915: clear up backlight #define confusion on gen4+")
from the drm tree.

The former removed the function ivb_pch_pwm_override() that is modified
by the latter, so I did that - or should I have just ignored the revert
patch?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__29_Jun_2012_13_30_46_+1000_iJ1qK3BsjEMNcDQj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP7SFmAAoJEECxmPOUX5FEdA4QAIE3XivrTKscl1DvaOJfbgh2
UKbD4Z3QcKPWmLrY+E/38Hkhgq+UqVQzjmetzAzoGvSjI4fHu6tXYFdp1FlvODhB
su+FSYqGnqqHnEAtq/VhfCtW8dPZfoSu33E8gtyEfXlYcuORVNWNDwRGS0s4hLm3
yb93heBzM7ziSL7GWpkVOULgRNc0WCrz3CmiVK/2MoNgFSKQsqv/pmh51TmGL4Ur
ydFGkhUWxcDQ3DNZjTC9Batjn6B0XZRkc3nCRGTdTJ+ra+lkN1U7N1XW9N4dvwDz
/NJ9CA59gkILN8EbifNFZFDzU/D7KaCM2I28UPV+BX5GcqW9FBgj5QHCtjEtsOpr
og5eYLcqrSVkzjCEI26ODs7stg3szwyzxjfr/en5aHme1bViL8cZQy84Ad4+SbTE
qMk70N9m7qZLtRuCM7uYfNwhypBrmreUQK9S0+gcfjoDpjlVtGS5hbdeCV1glSnJ
hLpsFMM0lWLvSnmMS3ses5T3Dz7qpg2xojmZpbng7+Pdk9TBsnZkR8lvR9KgJ55v
sKZlGB+JCg4EbhJCiofKro3rlE2390LP5NQeHPgVt+AQ5rMn4CV/LBRlNvSB9URX
L97GwQPl/dfD7HSO0g07KxHWx+HK5lGFbiu7N7X4hCNGw5xgEAZwuD2gBbcXnJXW
TOZFWa14Ph3Rq/ZFtGzC
=P84T
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jun_2012_13_30_46_+1000_iJ1qK3BsjEMNcDQj--
