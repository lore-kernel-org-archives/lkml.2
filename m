Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab2AITZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:25:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932942Ab2AITZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:25:13 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 2/8] s390: tape_class.h: remove kobj_map.h inclusion
Date: Mon,  9 Jan 2012 11:24:59 -0800
Message-Id: <1326137105-9960-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1326137105-9960-1-git-send-email-gregkh@suse.de>
References: <20120109190736.GA9440@kroah.com>
 <1326137105-9960-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This include file is not needed for any driver to be referencing, so
remove it from the tape_class.h file.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/s390/char/tape_class.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/char/tape_class.h b/drivers/s390/char/tape_class.h
index 9e32780..ba2092f 100644
--- a/drivers/s390/char/tape_class.h
+++ b/drivers/s390/char/tape_class.h
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/major.h>
-#include <linux/kobj_map.h>
 #include <linux/cdev.h>
 
 #include <linux/device.h>
-- 
1.7.8

