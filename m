Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0LAObQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:31:16 -0500
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:35699 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab0LAObP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:31:15 -0500
Subject: [PATCH] rtc: Add missing include to gef_wdt.
To: Wim Van Sebroeck <wim@iguana.be>
From: Martyn Welch <martyn.welch@ge.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 01 Dec 2010 14:31:11 +0000
Message-ID: <20101201143111.9151.66175.stgit@ES-BJ21R4J>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing include "linux/fs.h"i. Fixes compile failure.

Signed-off-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/watchdog/gef_wdt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index 9c21d19..34f64ad 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -34,6 +34,7 @@
 #include <linux/of_platform.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/fs.h>
 
 #include <sysdev/fsl_soc.h>
 


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
