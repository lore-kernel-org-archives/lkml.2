Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab1CRJhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:37:21 -0400
Received: from ebb05.tieto.com ([131.207.168.36]:53891 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab1CRJhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:37:17 -0400
X-AuditID: 83cfa824-b7b21ae000000a96-55-4d8327ccd32e
From: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
To: <linux-i2c@vger.kernel.org>
CC: <arnd@arndb.de>, <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <hthebaud@insidefr.com>, <matti.j.aaltonen@nokia.com>,
        Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Fri, 18 Mar 2011 11:40:23 +0100
Message-ID: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated patch after Arnd's comments.

Waldek

Waldemar Rymarkiewicz (1):
  NFC: Driver for Inside Secure MicroRead NFC chip

 Documentation/nfc/nfc-microread.txt |   46 ++++
 drivers/nfc/Kconfig                 |   10 +
 drivers/nfc/Makefile                |    1 +
 drivers/nfc/microread.c             |  465 +++++++++++++++++++++++++++++++++++
 include/linux/nfc/microread.h       |   31 +++
 5 files changed, 553 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/nfc/nfc-microread.txt
 create mode 100644 drivers/nfc/microread.c
 create mode 100644 include/linux/nfc/microread.h

