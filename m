Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab0KDPdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:33:44 -0400
Received: from smtp.nokia.com ([147.243.1.47]:24261 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab0KDPdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:33:42 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org, akpm@kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v4 0/1] NFC: PN544 driver.
Date: Thu,  4 Nov 2010 17:32:02 +0200
Message-Id: <1288884723-12156-1-git-send-email-matti.j.aaltonen@nokia.com>
X-Mailer: git-send-email 1.6.1.3
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Removed the erroneous reference to SWP (Single Wire Protocol) from 
the patch description and the document file.

Cheers,
Matti

Matti J. Aaltonen (1):
  NFC: Driver for NXP Semiconductors PN544 NFC chip.

 Documentation/nfc/nfc-pn544.txt |  114 +++++
 drivers/Kconfig                 |    2 +
 drivers/Makefile                |    2 +-
 drivers/nfc/Kconfig             |   30 ++
 drivers/nfc/Makefile            |    5 +
 drivers/nfc/pn544.c             |  891 +++++++++++++++++++++++++++++++++++++++
 include/linux/nfc/pn544.h       |   97 +++++
 7 files changed, 1140 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/nfc/nfc-pn544.txt
 create mode 100644 drivers/nfc/Kconfig
 create mode 100644 drivers/nfc/Makefile
 create mode 100644 drivers/nfc/pn544.c
 create mode 100644 include/linux/nfc/pn544.h

