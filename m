Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab1E1MGf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 08:06:35 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:55040 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752234Ab1E1MGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 08:06:35 -0400
Date: Sat, 28 May 2011 13:06:35 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Clocksource: Remove useless forward declaration
Message-ID: <20110528120635.GA17941@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 include/linux/clocksource.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index d4646b4..9b7e9ac 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -20,7 +20,6 @@
 
 /* clocksource cycle base type */
 typedef u64 cycle_t;
-struct clocksource;
 
 /**
  * struct cyclecounter - hardware abstraction for a free running counter
