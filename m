Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1CCNZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 08:25:49 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:44017 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751798Ab1CCNZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 08:25:48 -0500
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX18oOZA4l24oAWYEKUv3PLlDFgpfJiCcZ9s9tErPBC
	bkSknErj3KAFbg
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Al Cho <acho@novell.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH v3 1/2] staging: keucr: remove unused typedef VOID
Date: Thu,  3 Mar 2011 14:25:07 +0100
Message-Id: <1299158708-16812-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <4D6F80D2.2000005@fastmail.fm>
References: <4D6F80D2.2000005@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
Changes:
v2 .. v3: add an "Signed-off-by:" line
---
 drivers/staging/keucr/common.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/keucr/common.h b/drivers/staging/keucr/common.h
index 8693c54..f2be045 100644
--- a/drivers/staging/keucr/common.h
+++ b/drivers/staging/keucr/common.h
@@ -1,7 +1,6 @@
 #ifndef COMMON_INCD
 #define COMMON_INCD
 
-typedef void VOID;
 typedef u8 BOOLEAN;
 typedef u8 BYTE;
 typedef u8 *PBYTE;
-- 
1.7.4.1

