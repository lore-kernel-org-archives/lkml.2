Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2KKMwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:52:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62817 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2KKMwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:52:44 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 0/3] staging: line6: replace CONFIG_LINE6_USB_DEBUG with dyndbg
Date: Sun, 11 Nov 2012 13:52:23 +0100
Message-Id: <1352638346-32273-1-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack <zonque@gmail.com> suggested the dyndbg mechanism which allows
dev_dbg() messages to be enabled/disabled at run-time.  This is more powerful
than the compile-time CONFIG_LINE6_USB_DEBUG option.

This patch series converts debug messages to dev_dbg() and drops the obsolete
CONFIG_LINE6_USB_DEBUG option.

Stefan Hajnoczi (3):
  staging: line6: replace DEBUG_MESSAGES() with dev_dbg()
  staging: line6: drop unused DEBUG_MESSAGES() macro
  staging: line6: drop unused CONFIG_LINE6_USB_DEBUG

 drivers/staging/line6/Kconfig  |  8 ------
 drivers/staging/line6/driver.c |  6 ++---
 drivers/staging/line6/driver.h |  6 -----
 drivers/staging/line6/pod.c    | 57 ++++++++++++++++--------------------------
 drivers/staging/line6/variax.c | 12 ++++-----
 5 files changed, 28 insertions(+), 61 deletions(-)

-- 
1.7.12.1

