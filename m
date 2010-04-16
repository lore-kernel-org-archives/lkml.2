Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab0DPL7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:59:16 -0400
Received: from mail2.donator.se ([217.16.195.8]:3062 "EHLO mail2.donator.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758167Ab0DPL7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:59:15 -0400
X-MDAV-Processed: mail2.donator.se, Fri, 16 Apr 2010 13:59:14 +0200
X-Spam-Processed: mail2.donator.se, Fri, 16 Apr 2010 13:59:12 +0200
	(not processed: spam filter heuristic analysis disabled)
X-Authenticated-Sender: jakob.viketoft@bitsim.com
X-MDRemoteIP: 10.99.195.158
X-Return-Path: jakob.viketoft@bitsim.com
X-Envelope-From: jakob.viketoft@bitsim.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <4BC8510B.3060202@bitsim.com>
Date: Fri, 16 Apr 2010 13:59:07 +0200
From: Jakob Viketoft <jakob.viketoft@bitsim.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
       Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH] colibri.h: Add #include
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Reply-To: jakob.viketoft@bitsim.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of mfp_cfg_t causes build errors without including <mach/mfp.h>.

CC: stable@kernel.org
CC: Daniel Mack <daniel@caiaq.de>
CC: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by Jakob Viketoft <jakob.viketoft@bitsim.com>


--- a/arch/arm/mach-pxa/include/mach/colibri.h	2010-03-15 
17:09:39.000000000 +0100
+++ b/arch/arm/mach-pxa/include/mach/colibri.h	2010-04-16 
13:53:29.000000000 +0200
@@ -2,6 +2,7 @@
  #define _COLIBRI_H_

  #include <net/ax88796.h>
+#include <mach/mfp.h>

  /*
   * common settings for all modules


