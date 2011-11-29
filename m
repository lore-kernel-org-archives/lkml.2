Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab1K2Thp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:37:45 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:45464 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753626Ab1K2Tho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:37:44 -0500
From: Joe Perches <joe@perches.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] nfc: Logging updates
Date: Tue, 29 Nov 2011 11:37:31 -0800
Message-Id: <cover.1322595343.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard logging styles

Joe Perches (4):
  nfc: Use standard logging styles
  nfc: Convert nfc_dbg to pr_debug
  nfc: Remove unused nfc_printk and nfc_<level> macros
  nfc: Remove function tracer like entry messages

 net/nfc/core.c     |   60 +++++++++++++-----------------------
 net/nfc/nci/core.c |   84 +++++++++++++++++++++------------------------------
 net/nfc/nci/data.c |   30 ++++++++++--------
 net/nfc/nci/ntf.c  |   83 ++++++++++++++++++++++++++-------------------------
 net/nfc/nci/rsp.c  |   84 ++++++++++++++++++++++++++-------------------------
 net/nfc/netlink.c  |   32 ++------------------
 net/nfc/nfc.h      |    7 ----
 net/nfc/rawsock.c  |   28 +++++++++--------
 8 files changed, 176 insertions(+), 232 deletions(-)

-- 
1.7.6.405.gc1be0

