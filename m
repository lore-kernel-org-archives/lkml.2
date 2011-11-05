Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab1KELAE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 07:00:04 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.98]:46785 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1KELAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 07:00:03 -0400
Date: Sat, 5 Nov 2011 12:00:01 +0100
From: Peter Feuerer <peter@piie.net>
To: mjg@redhat.com
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Feuerer <peter@piie.net>
Subject: [PATCH RESEND 3/3] acerhdf: Lowered default temp fanon/fanoff
 values
Message-Id: <20111105120001.b5ebbeda.peter@piie.net>
In-Reply-To: <20111105115917.3d64689c.peter@piie.net>
References: <20111014234055.2265c524.peter@piie.net>
	<20111014234334.a87a2388.peter@piie.net>
	<20111015223210.GC16432@liondog.tnic>
	<cone.1318721291.690132.3813.1000@zopiie>
	<20111016084300.GB32343@liondog.tnic>
	<20111016114100.88295b72.peter@piie.net>
	<20111016114251.a710b196.peter@piie.net>
	<20111016114423.2df6271c.peter@piie.net>
	<20111105115818.bd26dc8d.peter@piie.net>
	<20111105115917.3d64689c.peter@piie.net>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.7; i686-pc-linux-gnu)
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
Acked-by: Borislav Petkov <petkovbb@gmail.com>
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

