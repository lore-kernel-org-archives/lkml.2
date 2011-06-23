Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab1FWSIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:08:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:34672 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432Ab1FWRgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:52 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasiliy Kulikov <segoon@openwall.com>,
        Matthew Garrett <mjg@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 115/247] platform: x86: acer-wmi: world-writable sysfs threeg file
Date: Thu, 23 Jun 2011 13:33:03 -0400
Message-Id: <1308850515-15242-56-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b80b168f918bba4b847e884492415546b340e19d upstream.

Don't allow everybody to write to hardware registers.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/platform/x86/acer-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 9fa2643..7b32e9c 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -1066,7 +1066,7 @@ static ssize_t set_bool_threeg(struct device *dev,
 			return -EINVAL;
 	return count;
 }
-static DEVICE_ATTR(threeg, S_IWUGO | S_IRUGO | S_IWUSR, show_bool_threeg,
+static DEVICE_ATTR(threeg, S_IRUGO | S_IWUSR, show_bool_threeg,
 	set_bool_threeg);
 
 static ssize_t show_interface(struct device *dev, struct device_attribute *attr,
-- 
1.7.4.4

