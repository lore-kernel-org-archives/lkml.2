Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1DKUGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 16:06:40 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:52118 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab1DKUGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 16:06:40 -0400
From: Andrei Warkentin <andreiw@motorola.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, hjanssen@microsoft.com, haiyangz@microsoft.com,
        Andrei Warkentin <andreiw@motorola.com>
Subject: [PATCH] HV SynthHID: Fix compile error.
Date: Mon, 11 Apr 2011 15:01:32 -0500
Message-Id: <1302552092-8580-2-git-send-email-andreiw@motorola.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1302552092-8580-1-git-send-email-andreiw@motorola.com>
References: <1302552092-8580-1-git-send-email-andreiw@motorola.com>
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing include for <asm/delay.h>

Signed-off-by: Andrei Warkentin <andreiw@motorola.com>
---
 drivers/staging/hv/hv_mouse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 50147f8..c5020c0 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -23,6 +23,7 @@
 #include <linux/hiddev.h>
 #include <linux/pci.h>
 #include <linux/dmi.h>
+#include <asm/delay.h>
 
 #include "hv_api.h"
 #include "logging.h"
-- 
1.7.0.4

