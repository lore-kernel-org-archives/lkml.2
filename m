Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab1ETALQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:16 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52626 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933217Ab1ETALM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:12 -0400
X-Sasl-enc: DgHN9HLMMUxtosIO7YtLu05Ud1Wa67cbktO/jcMwNg8r 1305850271
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/44] firmware: Fix grammar in sysfs-firmware-dmi doc
Date: Thu, 19 May 2011 17:10:22 -0700
Message-Id: <1305850262-9575-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

Fix the grammar in describing the position attribute of DMI entries in
the dmi-sysfs module.  While here, make a couple other small clarifying
fixups to the docs.

Reported-by: <Valdis.Kletnieks@vt.edu>
Signed-off-by: Mike Waychison <mikew@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ABI/testing/sysfs-firmware-dmi |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Documentation/ABI/testing/sysfs-firmware-dmi
index ba9da95..c78f9ab 100644
--- a/Documentation/ABI/testing/sysfs-firmware-dmi
+++ b/Documentation/ABI/testing/sysfs-firmware-dmi
@@ -14,14 +14,15 @@ Description:
 
 		DMI is structured as a large table of entries, where
 		each entry has a common header indicating the type and
-		length of the entry, as well as 'handle' that is
-		supposed to be unique amongst all entries.
+		length of the entry, as well as a firmware-provided
+		'handle' that is supposed to be unique amongst all
+		entries.
 
 		Some entries are required by the specification, but many
 		others are optional.  In general though, users should
 		never expect to find a specific entry type on their
 		system unless they know for certain what their firmware
-		is doing.  Machine to machine will vary.
+		is doing.  Machine to machine experiences will vary.
 
 		Multiple entries of the same type are allowed.  In order
 		to handle these duplicate entry types, each entry is
@@ -67,25 +68,24 @@ Description:
 			  and the two terminating nul characters.
 		type	: The type of the entry.  This value is the same
 			  as found in the directory name.  It indicates
-			  how the rest of the entry should be
-			  interpreted.
+			  how the rest of the entry should be interpreted.
 		instance: The instance ordinal of the entry for the
 			  given type.  This value is the same as found
 			  in the parent directory name.
-		position: The position of the entry within the entirety
-			  of the entirety.
+		position: The ordinal position (zero-based) of the entry
+			  within the entirety of the DMI entry table.
 
 		=== Entry Specialization ===
 
 		Some entry types may have other information available in
-		sysfs.
+		sysfs.  Not all types are specialized.
 
 		--- Type 15 - System Event Log ---
 
 		This entry allows the firmware to export a log of
 		events the system has taken.  This information is
 		typically backed by nvram, but the implementation
-		details are abstracted by this table.  This entries data
+		details are abstracted by this table.  This entry's data
 		is exported in the directory:
 
 		/sys/firmware/dmi/entries/15-0/system_event_log
-- 
1.7.4.2

