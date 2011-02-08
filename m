Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab1BHWSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:18:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40099 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab1BHWRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:17:23 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=wQI09XP816YA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=mLB1ou05ELASDr6fn6YA:9 a=oTAsKbZ22xPWnDzmNwAA:7 a=B6_irCaxWqVgUKyucwK2Ux53vxUA:4 a=XNN-oNMjSfgA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208221720.579342174@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Feb 2011 17:16:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 07/10] trivial: Fix Stevens Copyright typos
References: <20110208221612.084294240@goodmis.org>
Content-Disposition: inline; filename=0007-trivial-Fix-Steven-s-Copyright-typos.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>

OK, the copyright allows you to write a copy, still I think the lawyers
prefer the correct spelling.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
LKML-Reference: <1295899921-11333-1-git-send-email-u.kleine-koenig@pengutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/kconfig/streamline_config.pl |    2 +-
 tools/testing/ktest/ktest.pl         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
index fd81fc3..a4fe923 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -1,6 +1,6 @@
 #!/usr/bin/perl -w
 #
-# Copywrite 2005-2009 - Steven Rostedt
+# Copyright 2005-2009 - Steven Rostedt
 # Licensed under the terms of the GNU GPL License version 2
 #
 #  It's simple enough to figure out how this works.
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index e1c62ee..ba7c63a 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1,6 +1,6 @@
 #!/usr/bin/perl -w
 #
-# Copywrite 2010 - Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
+# Copyright 2010 - Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
 # Licensed under the terms of the GNU GPL License version 2
 #
 
-- 
1.7.2.3


