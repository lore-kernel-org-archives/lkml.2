Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1HZUeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:34:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab1HZUd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:33:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Mike Waychison <mikew@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/13] firmware: fix google/gsmi.c build warning
Date: Fri, 26 Aug 2011 13:33:42 -0700
Message-Id: <1314390834-3411-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <20110826191130.GA5557@kroah.com>
References: <20110826191130.GA5557@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Modify function parameter type to match expected type.  Fixes a
build warning:

drivers/firmware/google/gsmi.c:473: warning: initialization from incompatible pointer type

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mike Waychison <mikew@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/google/gsmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 68810fd..aa83de9 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -420,7 +420,7 @@ static efi_status_t gsmi_get_next_variable(unsigned long *name_size,
 
 static efi_status_t gsmi_set_variable(efi_char16_t *name,
 				      efi_guid_t *vendor,
-				      unsigned long attr,
+				      u32 attr,
 				      unsigned long data_size,
 				      void *data)
 {
-- 
1.7.6.1

