Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab1CGGPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 01:15:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50459 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1CGGPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 01:15:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=R/AM+zyOsDosQYWDww81nETm+9qCkO6cHiLUIxJsXWauKdR9VaZvOclfet7byjccxj
         irAmI6f0c7tdxHVqG8PKHAh1VZzLhIWCP8UUR73qu0QckaoymmmCpTLJJA6HE1EXRsbF
         C2kST5a96B28bMKy/TdXdxlQgrA7YKYf1M3rU=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mchehab@redhat.com, liplianin@netup.ru, gregkh@suse.de,
        Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH next] staging: altera-stapl: include delay.h
Date: Mon,  7 Mar 2011 09:15:00 +0300
Message-Id: <1299478500-16512-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error: altera-jtag.c:398:3: error: implicit declaration of
function 'udelay'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/altera-stapl/altera-jtag.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/altera-stapl/altera-jtag.c b/drivers/staging/altera-stapl/altera-jtag.c
index 6b633b1..b554f4d 100644
--- a/drivers/staging/altera-stapl/altera-jtag.c
+++ b/drivers/staging/altera-stapl/altera-jtag.c
@@ -25,6 +25,7 @@
 
 #include <linux/firmware.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 #include <staging/altera.h>
 #include "altera-exprt.h"
 #include "altera-jtag.h"
-- 
1.7.4.1

