Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3AHIsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 03:48:35 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:57003 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab3AHIsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 03:48:33 -0500
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH -next] mei: Fix typo "@hader" in mei_write_message()
Date: Tue,  8 Jan 2013 09:48:16 +0100
Message-Id: <1357634896-9944-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was introduced by:

commit 438763f37eb9664b6372bdfee990f8c33acdc63c
"mei: drop redundant length parameter from mei_write_message function"

First seen in linux-next (next-20120108).

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/misc/mei/interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/interface.c
index 155bd7e..651eacf 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/interface.c
@@ -202,7 +202,7 @@ int mei_hbuf_empty_slots(struct mei_device *dev)
  * mei_write_message - writes a message to mei device.
  *
  * @dev: the device structure
- * @hader: mei HECI header of message
+ * @header: mei HECI header of message
  * @buf: message payload will be written
  *
  * This function returns -EIO if write has failed
-- 
1.7.9.5

