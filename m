Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab1GKCh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 22:37:26 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:40988 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756670Ab1GKChX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 22:37:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Subject:Message-ID:In-Reply-To:X-Mailer:X-Identified-User;
	b=luNq5D4q8I2gJb+pQ8z8HIrt7cuRCPn4d5M5jadb/gZr90FSfjno6d8Kht/b8WLel0ad/49lDDtsypms3gH+P/bCwmwh7Di9ySBQmHIn2lA/8ev6ouebNbKU9NlCsrLK;
Date: Sun, 10 Jul 2011 19:21:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-wimax@intel.com
Cc: wimax@linuxwimax.org
Cc: rdunlap@xenotime.net
Subject: [PATCH 1/1] wimax: delete struct wimax_dev field rfkill_input
Message-ID: <1310350888180@xenotime.net>
In-Reply-To: 
X-Mailer: gregkh_patchbomb
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

"make htmldocs" warns that struct member "rfkill_input" does not have
a description.  After searching all kernel .[hc] files, this field
is not used, so remove it.

Warning(include/net/wimax.h:432): No description found for parameter 'rfkill_input'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 include/net/wimax.h |    1 -
 1 file changed, 1 deletion(-)

--- linux-3.0-rc6-git6.orig/include/net/wimax.h
+++ linux-3.0-rc6-git6/include/net/wimax.h
@@ -423,7 +423,6 @@ struct wimax_dev {
 	int (*op_reset)(struct wimax_dev *wimax_dev);
 
 	struct rfkill *rfkill;
-	struct input_dev *rfkill_input;
 	unsigned rf_hw;
 	unsigned rf_sw;
 	char name[32];


-- 

