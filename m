Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab0GUFHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:07:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49232 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762253Ab0GUE5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HYra/fvN4mRoxASNerRXiAoO+6NIohfgsg5xTrFJEFehdMZqfcudqon404NpPdoYmS
         9cE2GlfxAShtUnRW/d4Eg56kXi6Lr0zKVlveyw+Zq+07ewKe3W8XBpbovM+9gTmX5A4S
         JXY/8CKxBKM/OUFm/h+J9CNotmVADo+aOU2ms=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 106/106]Documentation/scsi/Mylex.txt update web address.
Date: Tue, 20 Jul 2010 21:57:45 -0700
Message-Id: <1279688279-29683-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/scsi/Mylex.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scsi/Mylex.txt b/Documentation/scsi/Mylex.txt
index cdf6929..3797f3e 100644
--- a/Documentation/scsi/Mylex.txt
+++ b/Documentation/scsi/Mylex.txt
@@ -2,4 +2,4 @@ Please see the file README.BusLogic for information about Linux support for
 Mylex (formerly BusLogic) MultiMaster and FlashPoint SCSI Host Adapters.
 
 The Mylex DAC960 PCI RAID Controllers are now supported.  Please consult
-http://www.dandelion.com/Linux/ for further information on the DAC960 driver.
+http://sourceforge.net/projects/dandelion for further information on the DAC960 driver.
-- 
1.7.1.rc1.21.gf3bd6

