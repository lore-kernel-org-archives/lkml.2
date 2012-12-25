Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2LYRG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 12:06:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:16881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab2LYRGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 12:06:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,353,1355126400"; 
   d="scan'208";a="184664336"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 00/14] mei: cleanups
Date: Tue, 25 Dec 2012 19:05:58 +0200
Message-Id: <1356455172-31959-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is resned of the mei driver cleanup series
1. Patch  'mei: use wrietl/readl instead of io wrappers' was dropped
 as suggested by Alan Cox and series was rebased
2. Fixed some typos in the commit messages


Tomas Winkler (14):
  mei: drop redundant length parameter from mei_write_message function
  mei: use unified format for printing mei message header
  mei: move internal host clients ids to mei_dev.h from hw.h
  mei: extract device dependent constants into hw-me.h
  mei: include local headers after the system ones
  mei: kill not used BAR0 length and base variables
  mei: mei_me_client is not hw API move to mei_dev.h
  mei: move hw dependent functions to interface.c
  mei: move host bus message handling to hbm.c
  mei: drop nonexistent function prototype
  mei: simplify preparing client host bus messages
  mei: use structured buffer for the write buffer
  mei: add common prefix to hbm function
  mei: move hbm responses from interrupt.c to hbm.c

 drivers/misc/mei/Makefile    |    1 +
 drivers/misc/mei/amthif.c    |   42 ++--
 drivers/misc/mei/hbm.c       |  631 ++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/hw-me.h     |  167 +++++++++++
 drivers/misc/mei/hw.h        |  125 +--------
 drivers/misc/mei/init.c      |  123 +--------
 drivers/misc/mei/interface.c |  187 +++++++------
 drivers/misc/mei/interface.h |   16 +-
 drivers/misc/mei/interrupt.c |  515 ++--------------------------------
 drivers/misc/mei/iorw.c      |    8 +-
 drivers/misc/mei/main.c      |   11 +-
 drivers/misc/mei/mei_dev.h   |  131 +++------
 drivers/misc/mei/wd.c        |   23 +-
 13 files changed, 1037 insertions(+), 943 deletions(-)
 create mode 100644 drivers/misc/mei/hbm.c
 create mode 100644 drivers/misc/mei/hw-me.h

-- 
1.7.4.4

