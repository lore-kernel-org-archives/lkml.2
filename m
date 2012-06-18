Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2FRPWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:22:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33963 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2FRPWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:22:03 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv3 0/4] remoteproc: Custom firmware handling.
Date: Mon, 18 Jun 2012 17:21:51 +0200
Message-Id: <1340032915-10734-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Hi Ohad,
This patchset is rebased to v3.5-rc3. I fixed some minor kernel-doc issues
for fw_ops, and some commit messages. 
Otherwise there are no changes since last time.

Regards,
Sjur

Sjur Brændeland (4):
  remoteproc: Pass struct fw to load_segments and find_rsc_table.
  remoteproc: Add function rproc_get_boot_addr
  remoteproc: Move Elf related functions to separate file
  remoteproc: Support custom firmware handlers

 drivers/remoteproc/Makefile                |    1 +
 drivers/remoteproc/remoteproc_core.c       |  251 +-----------------------
 drivers/remoteproc/remoteproc_elf_loader.c |  289 ++++++++++++++++++++++++++++
 drivers/remoteproc/remoteproc_internal.h   |   36 ++++
 include/linux/remoteproc.h                 |   22 ++
 5 files changed, 357 insertions(+), 242 deletions(-)
 create mode 100644 drivers/remoteproc/remoteproc_elf_loader.c

-- 
1.7.5.4

