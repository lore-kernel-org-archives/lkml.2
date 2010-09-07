Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0IGNP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:15:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61687 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab0IGNPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Wu5+KEIZIKFCikUcNzyMzbVuqagSjOxwe9PssA8esrMCufcaPaYCCGvMHezf/mv8x0
         3e16lrpEDwupyU/YX3jBefIiYHP8/+70fM+5oMZewCqkkEx0dWJf/LoAEWLUiksDwDpz
         vj8kbrowIZQr+qXvb8OX3+Yg739W/X7tfFZ1Q=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: pshah.mumbai@gmail.com, julia@diku.dk, daniele.boncompagni@gmail.com,
        a.beregalov@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Staging: otus: removes global variable initialization to 0 in wwrap.c
Date: Tue,  7 Sep 2010 18:44:50 +0530
Message-Id: <6c0c2afab52a5ae4dfc18bc0b065c3bf656abe07.1283865137.git.pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <7e1ccc28be954d553b6daddf54dbc149f27c709f.1283865137.git.pshah.mumbai@gmail.com>
References: <3f9402c47b6c1e56310bc43ea624bae01dce826f.1283865137.git.pshah.mumbai@gmail.com>
 <7e1ccc28be954d553b6daddf54dbc149f27c709f.1283865137.git.pshah.mumbai@gmail.com>
In-Reply-To: <3f9402c47b6c1e56310bc43ea624bae01dce826f.1283865137.git.pshah.mumbai@gmail.com>
References: <3f9402c47b6c1e56310bc43ea624bae01dce826f.1283865137.git.pshah.mumbai@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the wwrap.c file that removes the initialization
of global variable 'smp_kevent_Lock' to 0

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/otus/wwrap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
index eee2f56..cab9ffb 100644
--- a/drivers/staging/otus/wwrap.c
+++ b/drivers/staging/otus/wwrap.c
@@ -939,7 +939,7 @@ u32_t zfwReadReg(zdev_t *dev, u32_t offset)
 
 #define KEVENT_WATCHDOG        0x00000001
 
-u32_t smp_kevent_Lock = 0;
+u32_t smp_kevent_Lock;
 
 void kevent(struct work_struct *work)
 {
-- 
1.6.0.4

