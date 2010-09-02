Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0IBVJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:09:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41439 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0IBVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:09:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YfixC/XtCMVQk6ZaWFEJ4pcDUH0mePHwWTcBfnWcltZOkW8YnxGSshaPfFp6W2ZDmM
         qH6VEOEB7XLEsy2LPjq0jBNROuloHqyBO4W1jVj+Wwz7CCaAXZdMMHj/7L42Zhx3sTHa
         ThA6p54AlS0ZDBWqLZ/P63d6aPeQpOCc61dGw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 36/91] arch/m68k/mac/macboing.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:08:57 -0700
Message-Id: <1283461746-7905-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
References: <1283461746-7905-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/m68k/mac/macboing.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/mac/macboing.c b/arch/m68k/mac/macboing.c
index 8f06408..e1e3377 100644
--- a/arch/m68k/mac/macboing.c
+++ b/arch/m68k/mac/macboing.c
@@ -114,7 +114,7 @@ static void mac_init_asc( void )
 			 *   16-bit I/O functionality.  The PowerBook 500 series computers
 			 *   support 16-bit stereo output, but only mono input."
 			 *
-			 *   http://til.info.apple.com/techinfo.nsf/artnum/n16405
+			 *   http://www.apple.com/
 			 *
 			 * --David Kilzer
 			 */
-- 
1.7.2.1

