Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2DRADM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:03:12 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:59221 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753624Ab2DRADJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:03:09 -0400
Message-ID: <4F8E04E2.3090607@xenotime.net>
Date: Tue, 17 Apr 2012 17:03:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] input: fix input.h kernel-doc warning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warning in input.h:

Warning(include/linux/input.h:140): No description found for parameter 'len'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 include/linux/input.h |    1 +
 1 file changed, 1 insertion(+)

--- lnx-34-rc3.orig/include/linux/input.h
+++ lnx-34-rc3/include/linux/input.h
@@ -116,6 +116,7 @@ struct input_keymap_entry {
 
 /**
  * EVIOCGMTSLOTS(len) - get MT slot values
+ * @len: size of the data buffer in bytes
  *
  * The ioctl buffer argument should be binary equivalent to
  *
