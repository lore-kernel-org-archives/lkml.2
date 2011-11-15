Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1KOIfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 03:35:07 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57543 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1KOIfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 03:35:05 -0500
MIME-Version: 1.0
Date: Tue, 15 Nov 2011 09:35:04 +0100
Message-ID: <CACRpkdYc4f+VkkgrBvC7p9DgkbM3WHNkPYeUnPw=F3AkPo1Ztg@mail.gmail.com>
Subject: [GIT PULL] pinctrl fixes
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

could you please pull these two patches for the pinctrl
subsystem into the 3.2-rc series, the one from me contains
the Kconfig fixup you requested after the initial merge.

Thanks,
Linus Walleij

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.linaro.org/people/triad/linux-pinctrl.git fixes

Barry Song (1):
      pinctrl: fix "warning: 'struct pinctrl_dev' declared inside
parameter list"

Linus Walleij (1):
      pinctrl: hide subsystem from the populace

 drivers/pinctrl/Kconfig         |   22 +++++++---------------
 include/linux/pinctrl/pinctrl.h |    1 +
 2 files changed, 8 insertions(+), 15 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOwiPIAAoJEEEQszewGV1z9qQP/RmA0KIolR9ubl/aOU60GpXE
XGqYZ6aGEdCewJ15d9ofRQHo5zVAgKI9lbTVA5V1kkfVjs2+hEN41P1bX7JEgLbB
jS33jVvjFi8apEoZCeGaUzXE+I73FKCfi/KEOPhOYvvqQi4CS0RkYPz1Wexs49YG
pCJ6m17MAj1dLVPkbJllbtAuuxaIYBgWuz2njS7vimvg2AdLMlouaPPjF5WFTPj+
+ScSdZbtXgv3s0UBPthTzjxBeuuGujhmYsR29VQ1mStT4Z0ybzj3yk2LEkkv7Bry
ehdrPkuTD3D3W3O2LhZ1K9z7v8g9w23+XErEK6W4sONpde5d9fCP2KKkuvZrsOSV
knNF3uL7FZKiQRr2G/kL6MREdRVNuVNCbs047zJj6mHjcrSfdUOhYi7RDNk+Retq
U5wqE0/t8mjgJekcMAlq5S104QOZpdwtUu2r1Vw4smBQUCkpQFKlmlV/1FhpVqzg
oYG1uk7ogLDeX06RUVc7Hhz2lh649YVARCy3ZMRY6aGRbfid4rKMUDqwChquetT9
LttltuYE1oSjFbUPhRlZwP62QgvB9kNUFXZKV3zOsaZ6wXskZ2lwFpsWfvieQfCS
60DuSORWVLeGgiJSbmSgw3NY5yPrjyQcAWce8k6avq/5eTaUvStVCqOCKaNYQA/c
i2CjP7VgKVTmUqUgRono
=yLjg
-----END PGP SIGNATURE-----
