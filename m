Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286Ab0GUE6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:58:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37757 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933399Ab0GUE4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:56:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=t73DyEWjZolE3EetoB+HXDgtStefpB+yhISy2Q6LGHqjDQgNvpwhQEY1nwUDn2tPJH
         RV6F5HLMWVN0XRRJGhSTTUA7olItODIrO3hoPpQjGd8vKDJgpdtqcRCZzKNT0ipuZgfC
         prebVjPlVINnTJJDTtaCjtYDiBQcnSb6WLoYQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 95/95]Documentation/scsi/BusLogic.txt update web address.
Date: Tue, 20 Jul 2010 21:56:45 -0700
Message-Id: <1279688215-29628-5-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
References: <1279688215-29628-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/scsi/BusLogic.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scsi/BusLogic.txt b/Documentation/scsi/BusLogic.txt
index 98023ba..d7fbc94 100644
--- a/Documentation/scsi/BusLogic.txt
+++ b/Documentation/scsi/BusLogic.txt
@@ -47,7 +47,7 @@ tune driver performance and error recovery to their particular needs.
 The latest information on Linux support for BusLogic SCSI Host Adapters, as
 well as the most recent release of this driver and the latest firmware for the
 BT-948/958/958D, will always be available from my Linux Home Page at URL
-"http://www.dandelion.com/Linux/".
+"http://sourceforge.net/projects/dandelion/".
 
 Bug reports should be sent via electronic mail to "lnz@dandelion.com".  Please
 include with the bug report the complete configuration messages reported by the
-- 
1.7.1.rc1.21.gf3bd6

