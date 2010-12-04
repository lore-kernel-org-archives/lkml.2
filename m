Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab0LDCdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 21:33:14 -0500
Received: from mail.perches.com ([173.55.12.10]:2204 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab0LDCdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 21:33:12 -0500
From: Joe Perches <joe@perches.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Add and use vsprintf extension %pMbt for bluetooth macs
Date: Fri,  3 Dec 2010 18:33:02 -0800
Message-Id: <cover.1291419007.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using vsprintf extensions can save text and data.
Add %pMbt for the byte reversed output for bluetooth addresses.

Joe Perches (2):
  vsprintf: Add %pMbt, bluetooth mac address
  bluetooth: Use printf extension %pMbt

 lib/vsprintf.c              |    6 +++++-
 net/bluetooth/bnep/core.c   |    3 +--
 net/bluetooth/cmtp/core.c   |    2 +-
 net/bluetooth/hci_conn.c    |    6 +++---
 net/bluetooth/hci_core.c    |    8 ++++----
 net/bluetooth/hci_event.c   |    6 +++---
 net/bluetooth/hci_sysfs.c   |   10 +++++-----
 net/bluetooth/hidp/core.c   |    4 ++--
 net/bluetooth/l2cap.c       |   19 +++++++++----------
 net/bluetooth/lib.c         |   14 --------------
 net/bluetooth/rfcomm/core.c |   16 ++++++++--------
 net/bluetooth/rfcomm/sock.c |    8 ++++----
 net/bluetooth/rfcomm/tty.c  |    6 +++---
 net/bluetooth/sco.c         |   12 ++++++------
 14 files changed, 54 insertions(+), 66 deletions(-)

-- 
1.7.3.2.245.g03276.dirty

