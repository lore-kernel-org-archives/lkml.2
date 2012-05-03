Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab2ECSC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:02:26 -0400
Received: from imr4.ericy.com ([198.24.6.9]:60041 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab2ECSCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:02:25 -0400
Date: Thu, 3 May 2012 11:00:12 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.4-rc6
Message-ID: <20120503180012.GA15983@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.4-rc6 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter

------

The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

for you to fetch changes up to bdc71c9a87b898e4c380c23b2e3e18071312ecde:

  hwmon: (coretemp) Increase CPU core limit (2012-05-01 09:16:14 -0700)

----------------------------------------------------------------
hwmon fixes for 3.4-rc6

Fix OOPS seen in coretemp driver if the CPU core ID is too large

----------------------------------------------------------------
Guenter Roeck (1):
      hwmon: (coretemp) Increase CPU core limit

Kirill A. Shutemov (1):
      hwmon: (coretemp) fix oops on cpu unplug

 drivers/hwmon/coretemp.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPoserAAoJEMsfJm/On5mBBcgP/jS39FBXx/XsHYmWrTpL/u7k
SyDzlkYnn04709+fWjF72NH7TOzJxRtVtM7BcVtpoibFDXIJI7DRUEsekMNLLZyz
dmT8D4Ju3MBbXxQT+hSNhDeype62VFoVAVsIMKD5urylulQYf7X0QJPEh+TYSmaQ
QLVbVV4d4wLgPtMPnTUyYTOMNpxcLAeydZRjq9T1UB0Sk+fgpUVYsjlZzrZGHFTp
MmTiLB+7xjGOCqBMDlzEQ+H7HrXxnpUUwvwluDiAiw6F6xJSsE++Zm2llECywWDq
BrBG066HFzy41FDqYS9x4cslH/k4wLKuVD43ytwkvLAHyIEZUEY7Ai2sGM7WQYws
eRbcg1iH/rrb3z2DVitAsxF98WTXzhDsrUKviyAnQKrsoghacEpbG3oeWjgHRgt2
0FxCUGoBIsoejzgO+Y4tXY5OUEc7GJ+dCrlITtuQg1GAsFHtY/120itU7Fhl6krf
NVPYYIVYlDCB+CXDKeRWrExl6Yv85aLRvlNsYcdsAq9ScrkxE/1CEeopW5gcMW/S
sS8glCOVMO4fPP8GM846wIwHOAtOhQY51NCd1THT9cAKeGIpgSirhTWWmTHm0Ogk
3e142EyFBWPUJvdE/YgcbBrBvk82sJH597BTBtYYZwkTal6h1tGWbHiapkr+iDv0
uPMJJ1MYrkQdp10R35pj
=pEKb
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
