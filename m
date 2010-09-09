Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab0IIW0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:26:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33330 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab0IIW0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=D+5u14PSgoKeNoQDNQnrOXpYoHaSpPV8a+V0dSGAsUBkcp6kc/I6OsJyhx2q1XcK7p
         pdO24iAK2GRcIuY1yB6N4UF6YZIY30uBoHpSQYSMw0nd9z/khk0bknRjRuOz7aQmwO04
         JFrIpvFhzFFc7HCbsM3jcpmin4tTSwvyRRBm0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 038/223]drivers/input/joystick/gamecon.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:26:38 -0700
Message-Id: <1284071205-7756-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
References: <1284071205-7756-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/input/joystick/gamecon.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/input/joystick/gamecon.c b/drivers/input/joystick/gamecon.c
index 0ffaf2c..2463b95 100644
--- a/drivers/input/joystick/gamecon.c
+++ b/drivers/input/joystick/gamecon.c
@@ -521,9 +521,8 @@ static void gc_multi_process_packet(struct gc *gc)
  * PSX support
  *
  * See documentation at:
- *	http://www.dim.com/~mackys/psxmemcard/ps-eng2.txt
+ *	http://forethought.net/	
  *	http://www.gamesx.com/controldata/psxcont/psxcont.htm
- *	ftp://milano.usal.es/pablo/
  *
  */
 
-- 
1.7.2.1

