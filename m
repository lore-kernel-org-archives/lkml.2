Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1JPJo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 05:44:26 -0400
Received: from smtprelay03.ispgateway.de ([80.67.29.28]:36210 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab1JPJoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 05:44:25 -0400
Date: Sun, 16 Oct 2011 11:44:23 +0200
From: Peter Feuerer <peter@piie.net>
To: mjg@redhat.com
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] acerhdf: Lowered default temp fanon/fanoff values
Message-Id: <20111016114423.2df6271c.peter@piie.net>
In-Reply-To: <20111016114251.a710b196.peter@piie.net>
References: <20111014234055.2265c524.peter@piie.net>
	<20111014234334.a87a2388.peter@piie.net>
	<20111015223210.GC16432@liondog.tnic>
	<cone.1318721291.690132.3813.1000@zopiie>
	<20111016084300.GB32343@liondog.tnic>
	<20111016114100.88295b72.peter@piie.net>
	<20111016114251.a710b196.peter@piie.net>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: NjUwNDc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Feuerer <peter@piie.net>

Due to new supported hardware, of which the actual temperature limits of
processor, harddisk and other components are unknown, it feels safer
with lower fanon / fanoff settings.

It won't change much for most people, already using acerhdf, as they use
their own fanon/fanoff variable settings when loading the module.

Furthermore seems like kernel and userspace tools have been improved
to work more efficient and netbooks don't get so hot anymore.

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/acerhdf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index f15e320..833c0ec 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -83,8 +83,8 @@ static int kernelmode;
 #endif
 
 static unsigned int interval = 10;
-static unsigned int fanon = 63000;
-static unsigned int fanoff = 58000;
+static unsigned int fanon = 60000;
+static unsigned int fanoff = 53000;
 static unsigned int verbose;
 static unsigned int fanstate = ACERHDF_FAN_AUTO;
 static char force_bios[16];
-- 
1.7.7

