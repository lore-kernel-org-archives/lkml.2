Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2FFNis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:38:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58275 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2FFNih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:38:37 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCH 0/7] remoteproc: Custom firmware handling.
Date: Wed,  6 Jun 2012 15:38:20 +0200
Message-Id: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Hi Ohad, 

I think I have addressed most of your review comments, except
dynamic detection of firmware format.

Warning: I have not been able to test this properly,
I don't yet have a proper test environment running.

Regards,
Sjur



Sjur Brændeland (7):
  remoteproc: fix print format warnings
  remoteproc: Fix missing fault indication in error-path
  remoteproc: Pass struct fw to load_segments and find_rsc_table.
  remoteproc: Assign boot_addr in a separate function
  remoteproc: Move Elf related functions to separate file
  remoteproc: Support custom firmware handlers
  remoteproc: Add custom STE-modem firmware loader.

 drivers/remoteproc/Kconfig                       |    4 +
 drivers/remoteproc/Makefile                      |    2 +
 drivers/remoteproc/omap_remoteproc.c             |    1 +
 drivers/remoteproc/remoteproc_core.c             |  257 +------------------
 drivers/remoteproc/remoteproc_elf_loader.c       |  287 ++++++++++++++++++++++
 drivers/remoteproc/remoteproc_ste_modem_loader.c |  176 +++++++++++++
 include/linux/remoteproc.h                       |   57 +++++
 7 files changed, 538 insertions(+), 246 deletions(-)
 create mode 100644 drivers/remoteproc/remoteproc_elf_loader.c
 create mode 100644 drivers/remoteproc/remoteproc_ste_modem_loader.c

-- 
1.7.5.4

