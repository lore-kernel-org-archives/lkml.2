Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab1KGN22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:28:28 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:47112 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab1KGN20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:28:26 -0500
Subject: [PATCH] [TRIVIAL] Documentation: 53c700: drop never defined
 (Kconfig) macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 14:28:22 +0100
Message-ID: <1320672502.14409.352.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/scsi/53c700.txt |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/Documentation/scsi/53c700.txt b/Documentation/scsi/53c700.txt
index 0da681d..e31aceb 100644
--- a/Documentation/scsi/53c700.txt
+++ b/Documentation/scsi/53c700.txt
@@ -16,32 +16,13 @@ fill in to get the driver working.
 Compile Time Flags
 ==================
 
-The driver may be either io mapped or memory mapped.  This is
-selectable by configuration flags:
-
-CONFIG_53C700_MEM_MAPPED
-
-define if the driver is memory mapped.
-
-CONFIG_53C700_IO_MAPPED
-
-define if the driver is to be io mapped.
-
-One or other of the above flags *must* be defined.
-
-Other flags are:
+A compile time flag is:
 
 CONFIG_53C700_LE_ON_BE
 
 define if the chipset must be supported in little endian mode on a big
 endian architecture (used for the 700 on parisc).
 
-CONFIG_53C700_USE_CONSISTENT
-
-allocate consistent memory (should only be used if your architecture
-has a mixture of consistent and inconsistent memory).  Fully
-consistent or fully inconsistent architectures should not define this.
-
 
 Using the Chip Core Driver
 ==========================
-- 
1.7.4.4



