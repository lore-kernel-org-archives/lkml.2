Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab2KXAac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:30:32 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:33944 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450Ab2KXA1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:35 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 12/24] MAINTAINERS: remove drivers/staging/hv/
Date: Fri, 23 Nov 2012 22:26:36 -0200
Message-Id: <1353716808-16375-13-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This directory was removed by commit 89ae7d7 (hv: storvsc: Move the
storage driver out of the staging area).

Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 887d717..91feba2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3619,7 +3619,6 @@ S:	Maintained
 F:	drivers/hv/
 F:	drivers/hid/hid-hyperv.c
 F:	drivers/net/hyperv/
-F:	drivers/staging/hv/
 
 I2C OVER PARALLEL PORT
 M:	Jean Delvare <khali@linux-fr.org>
-- 
1.7.11.7

