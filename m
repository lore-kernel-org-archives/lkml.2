Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab0FQIn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:43:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14682 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab0FQIny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EgHeU/vVRILk2/59a7PND/YeAsa538uX1zW9yPhQGHAela8XLGFbNE30gLwI9gCZAH
         HfkfT3Zf8Qc19fuCSLtkgArjO8Bey90IAixD9BthKdoqKiGuF8jykQ1FTsP+Y8sYLu/s
         tmMlWwM3MlTQqZH9t8LfEdEIAFfQMJvvKyuVM=
From: Matti Lammi <mattij.lammi@gmail.com>
To: gregkh@suse.de, mattij.lammi@gmail.com, mithlesh@linsyssoft.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Drivers: Staging: Moved one brace to its proper place.
Date: Thu, 17 Jun 2010 11:43:48 +0300
Message-Id: <1276764228-14657-1-git-send-email-mattij.lammi@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another small fix.

Signed-off-by: Matti Lammi <mattij.lammi@gmail.com>
---
 drivers/staging/otus/athr_common.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/otus/athr_common.h b/drivers/staging/otus/athr_common.h
index 3e32f5b..c58ffee 100644
--- a/drivers/staging/otus/athr_common.h
+++ b/drivers/staging/otus/athr_common.h
@@ -128,2 +128,2 @@ struct athr_wapi_param {
 	} u;
 };

-struct athr_wapi_sta_info
-{
+struct athr_wapi_sta_info{
 	u16	msg_type;
 	u16	datalen;
 	u8	sta_mac[ETH_ALEN];
--
1.6.0.4

