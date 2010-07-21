Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762162Ab0GUFI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:08:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49232 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449Ab0GUE5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hFhSg+IYDwJwkqutcPRVX4u4PkVh3vGqAiPc2Edj5SniR6XHSFuqq6b0JgCWXal+uH
         hxthUMyxmYaZTMcmQfhyxvIvMSkiz7VHdCmdtVvAu9hCV7FfhUnuRUQGQUJMvsmbOeaY
         9gWIWbyMY+feAJc15iCm+jcgb9VtD1m880QAc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 102/102]Documentation/scsi/FlashPoint.txt update web address.
Date: Tue, 20 Jul 2010 21:56:52 -0700
Message-Id: <1279688215-29628-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates broken web address

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/scsi/FlashPoint.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/scsi/FlashPoint.txt b/Documentation/scsi/FlashPoint.txt
index 1540a92..5b5f29c 100644
--- a/Documentation/scsi/FlashPoint.txt
+++ b/Documentation/scsi/FlashPoint.txt
@@ -13,7 +13,7 @@ operating system support to its BusLogic brand of FlashPoint Ultra SCSI
 host adapters.  All of BusLogic's other SCSI host adapters, including the
 MultiMaster line, currently support the Linux operating system.  Linux
 drivers and information will be available on October 15th at
-http://www.dandelion.com/Linux/.
+http://sourceforge.net/projects/dandelion/.
 
 "Mylex is committed to supporting the Linux community," says Peter Shambora,
 vice president of marketing for Mylex.  "We have supported Linux driver
@@ -27,7 +27,7 @@ Linux is a freely-distributed implementation of UNIX for Intel x86, Sun
 SPARC, SGI MIPS, Motorola 68k, Digital Alpha AXP and Motorola PowerPC
 machines.  It supports a wide range of software, including the X Window
 System, Emacs, and TCP/IP networking.  Further information is available at
-http://www.linux.org and http://www.ssc.com/linux.
+http://www.linux.org and http://www.ssc.com/.
 
 FlashPoint Host Adapters
 
-- 
1.7.1.rc1.21.gf3bd6

