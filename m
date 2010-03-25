Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab0CYRZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:25:00 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40717 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab0CYRXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=rymYuh2j5gWrAC2BEcTyUmAMdsUJDWl4abfrcW34JA+i5c9pZcepBxeIworfwrO37g
         O+NQExk83V/n3MmSP8BThbX3cVCsEK/uhVUjaMCiecSB4+e8hlINpJzpFLBDDOgbuIx2
         zLo9kmvody4vgEVs1yxhoOe4eq25f2uYeydJI=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Moritz Muehlenhoff <jmm@debian.org>,
       Andrew Elwell <Andrew.Elwell@gmail.com>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 08/16] Staging: wlan-ng: p80211wext.c: duplicated include
Date: Thu, 25 Mar 2010 18:22:39 +0100
Message-Id: <1269537767-7553-9-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/wlan-ng/p80211wext.c: linux/bitops.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 drivers/staging/wlan-ng/p80211wext.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 2fa1dfa..b6734e7 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -50,7 +50,6 @@
 #include <linux/uaccess.h>
 #include <asm/byteorder.h>
 #include <linux/if_ether.h>
-#include <linux/bitops.h>
 
 #include "p80211types.h"
 #include "p80211hdr.h"
-- 
1.7.0.3.296.g9776a

