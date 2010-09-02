Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0IBVIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:08:15 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60848 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab0IBVIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:08:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OATmBmu5HIO4d1sp/749A5oeN9BPm2eETPDEaP3W3cisjgBvUjm7RSUUQcTZdtuoXy
         q+7rC+/h73upmKOKequcYje+CYz9DTlVxyRSZEp3Ze4/v9StxPGr/FsHXYkuzIs7USjs
         9UO3a0UvtpJWKWWx/mTqmToezvErc6+48wCfA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 24/91] arch/avr32/Kconfig Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:07:53 -0700
Message-Id: <1283461679-7851-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
References: <1283461679-7851-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/avr32/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index f515727..787dcba 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -145,7 +145,7 @@ config BOARD_HAMMERHEAD
 	  will cover even the most exceptional need of memory bandwidth. Together with the onboard
 	  video decoder the board is ready for video processing.
 
-	  For more information see: http://www.miromico.com/hammerhead
+	  For more information see: http://www.hammerhead.ch/index.php/getting-started.html 
 
 config BOARD_FAVR_32
 	bool "Favr-32 LCD-board"
-- 
1.7.2.1

