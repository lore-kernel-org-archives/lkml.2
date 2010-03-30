Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0C3VlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 17:41:12 -0400
Received: from 152.Red-88-2-254.staticIP.rima-tde.net ([88.2.254.152]:53387
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753938Ab0C3VlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 17:41:10 -0400
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: devel@driverdev.osuosl.org
Cc: gregkh@suse.de, wfp5p@virginia.edu, bzolnier@gmail.com,
       alan@linux.intel.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: Add new driver ipheth
Date: Tue, 30 Mar 2010 23:34:23 +0200
Message-Id: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm submitting this new driver to the staging tree so it can be reviewed. I
didn't write it by myself, but I've tested it and it works just fine (at least
with a 3G iPhone). The original maintainers are not very responsive and the
codebase has not been updated (apart from minor fixes) since January.

Anyway, before submitting it I've fixed (most) checkpatch issues. Only two
over-80-characters lines issues are standing, but looking at the code it did
make sense for me letting those 3-4 characters to overflow to keep the code
readable.

More than that, I have no real experience with kernel programming (read LDD,
articles, files inside Documentation/ directory and so), so if you see obvious
bugs or something that should be fixed, please let me know with a pointer to the
documentation that may help me to undertand why it's wrong and how should I fix
it.

L. Alberto Giménez (1):
  Staging: Add new driver ipheth

 drivers/staging/Kconfig         |    2 +
 drivers/staging/Makefile        |    1 +
 drivers/staging/ipheth/Kconfig  |   11 +
 drivers/staging/ipheth/Makefile |    1 +
 drivers/staging/ipheth/ipheth.c |  573 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 588 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ipheth/Kconfig
 create mode 100644 drivers/staging/ipheth/Makefile
 create mode 100644 drivers/staging/ipheth/ipheth.c

