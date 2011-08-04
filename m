Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1HDNMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 09:12:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51898 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1HDNM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 09:12:26 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 4 Aug 2011 14:12:05 +0100
X-Google-Sender-Auth: 3IG_0FT9yK6B3z2DY3Xn_ds9KnM
Message-ID: <CACxGe6sK9n1GOJiVFg2EDJxMs2cDn4Ot1+k68eE2dU=PB0c=gg@mail.gmail.com>
Subject: [GIT PULL] Back out DT breakage that affects sparc
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

After discussing the design with David M., this tree reverts the
of_alias code that I send you yesterday and removes the user of it.
There are enough things that he was concerned about that it is
probably the best solution for right now.

g.

The following changes since commit a9e4e6e14c322e08d1c615afc8f504fb415f9613:

  Merge branch 'for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
(2011-08-03 15:12:09 -1000)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/merge

Grant Likely (2):
      dt: remove of_alias_get_id() reference
      Revert "dt: add of_alias_scan and of_alias_get_id"

 drivers/of/base.c        |  130 ----------------------------------------------
 drivers/of/fdt.c         |    4 +-
 drivers/tty/serial/imx.c |   13 ++---
 include/linux/of.h       |    8 ---
 include/linux/of_fdt.h   |    1 +
 5 files changed, 6 insertions(+), 150 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
