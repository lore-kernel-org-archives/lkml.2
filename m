Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab2FJLWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:22:48 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:45815 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755443Ab2FJLWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:22:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAKKA1E9bdWOb/2dsb2JhbABFtFqBB4IYAX8wbSISiA+3T5EQA5Uej3uCYg
X-IronPort-AV: E=Sophos;i="4.77,384,1336341600"; 
   d="scan'208";a="918717956"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, teddy.wang@siliconmotion.com.cn
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 0/3] staging: sm7xx: code improvements and cleanup
Date: Sun, 10 Jun 2012 13:12:21 +0200
Message-Id: <1339326744-17507-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This set of patches implement some code improvements, update comments
and clarify supported Silicon Motion chips.

This patch addresses a naming change too. The new name is coherent with
the stable framebuffer driver names. Patch handles the needed Kconfig
and Makefiles changes too. It is a required change to move it under
drivers/video in the future.

Javier M. Mellid (3):
  staging: sm7xx: code improvement
  staging: sm7xx: update comments and clarify supported chips
  staging: sm7xxfb: sm7xx becomes sm7xxfb

 drivers/staging/Kconfig           |    2 +-
 drivers/staging/Makefile          |    2 +-
 drivers/staging/sm7xx/Kconfig     |    8 -
 drivers/staging/sm7xx/Makefile    |    3 -
 drivers/staging/sm7xx/TODO        |    9 -
 drivers/staging/sm7xx/smtcfb.c    | 1096 ------------------------------------
 drivers/staging/sm7xx/smtcfb.h    |  780 --------------------------
 drivers/staging/sm7xxfb/Kconfig   |   13 +
 drivers/staging/sm7xxfb/Makefile  |    1 +
 drivers/staging/sm7xxfb/TODO      |    9 +
 drivers/staging/sm7xxfb/sm7xx.h   |  780 ++++++++++++++++++++++++++
 drivers/staging/sm7xxfb/sm7xxfb.c | 1097 +++++++++++++++++++++++++++++++++++++
 12 files changed, 1902 insertions(+), 1898 deletions(-)
 delete mode 100644 drivers/staging/sm7xx/Kconfig
 delete mode 100644 drivers/staging/sm7xx/Makefile
 delete mode 100644 drivers/staging/sm7xx/TODO
 delete mode 100644 drivers/staging/sm7xx/smtcfb.c
 delete mode 100644 drivers/staging/sm7xx/smtcfb.h
 create mode 100644 drivers/staging/sm7xxfb/Kconfig
 create mode 100644 drivers/staging/sm7xxfb/Makefile
 create mode 100644 drivers/staging/sm7xxfb/TODO
 create mode 100644 drivers/staging/sm7xxfb/sm7xx.h
 create mode 100644 drivers/staging/sm7xxfb/sm7xxfb.c

-- 
1.7.10

