Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1GYPYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:24:47 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:54079 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1GYPYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:24:41 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.89
Message-ID: <4E2D8905.2040405@tremplin-utc.net>
Date: Mon, 25 Jul 2011 17:17:25 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org
Subject: [PATCH 02/10] lis3: update maintainer information
References: <4E2D8858.8000900@tremplin-utc.net>
In-Reply-To: <4E2D8858.8000900@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the move of the lis3 driver, the hp_accel.c file got dropped from the
MAINTAINER file. Make it explicit again that this file is tied to lis3
again.

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 187282d..00f7325 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3937,6 +3937,7 @@ M:	Eric Piel <eric.piel@tremplin-utc.net>
 S:	Maintained
 F:	Documentation/misc-devices/lis3lv02d
 F:	drivers/misc/lis3lv02d/
+F:	drivers/platform/x86/hp_accel.c
 
 LLC (802.2)
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
-- 
1.7.6
