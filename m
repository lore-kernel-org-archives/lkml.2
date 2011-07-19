Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240Ab1GSVdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 17:33:39 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:33942 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1GSVdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 17:33:38 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>, Akinobu Mita <akinobu.mita@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v2 0/3] Make fault injection available for MMC IO
Date: Tue, 19 Jul 2011 23:31:43 +0200
Message-Id: <1311111106-26814-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first version of this patch is a part of mmc non-blocking v9 patchset:
[PATCH v9 11/12] mmc: core: add random fault injection

change log:
 v2 - Resolve build issue in mmc core.c due to multiple init_module by
      removing the fault inject module.
    - Export fault injection functions to make them available for modules
    - Update fault injection documentation on MMC IO  

Per Forlin (3):
  fault-inject: make fault injection available for modules
  mmc: core: add random fault injection
  fault injection: add documentation on MMC IO fault injection

 Documentation/fault-injection/fault-injection.txt |    5 ++
 drivers/mmc/core/core.c                           |   58 +++++++++++++++++++++
 drivers/mmc/core/debugfs.c                        |    5 ++
 include/linux/mmc/host.h                          |    3 +
 lib/Kconfig.debug                                 |   11 ++++
 lib/fault-inject.c                                |    2 +
 6 files changed, 84 insertions(+), 0 deletions(-)

-- 
1.7.4.1

