Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2LTAlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:41:45 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:39194 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2LTAlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:41:32 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 20 Dec 2012 00:41:11 +0000
X-Google-Sender-Auth: sWuZm0mcsdC0APhAkkDrTaDDys8
Message-ID: <CACxGe6s=bSa6ymfad10uP4OkgO+N7ZV0x6LrCtWXc=ww=kJi2w@mail.gmail.com>
Subject: [GIT PULL] Device tree bug fixes for v3.8 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Herring <robherring2@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Some straight forward bug fixes. Please pull

g.

The following changes since commit 752451f01c4567b506bf4343082682dbb8fb30dd:

  Merge branch 'i2c-embedded/for-next' of
git://git.pengutronix.de/git/wsa/linux (2012-12-18 16:51:10 -0800)

are available in the git repository at:


  git://git.secretlab.ca/git/linux-2.6 tags/dt-for-linus

for you to fetch changes up to ab28698d33af05abab0bcf8021eafe38f7434f24:

  of: define struct device in of_platform.h if !OF_DEVICE and
!OF_ADDRESS (2012-12-19 16:15:17 +0000)

----------------------------------------------------------------
Device tree v3.8 bug fix branch. Fixes an undefined struct device build
error and a missing symbol export.

----------------------------------------------------------------
Grant Likely (1):
      of: Fix export of of_find_matching_node_and_match()

Jonas Gorski (1):
      of: define struct device in of_platform.h if !OF_DEVICE and !OF_ADDRESS

 drivers/of/base.c           |    2 +-
 include/linux/of_platform.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)


--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
