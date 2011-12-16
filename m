Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab1LPUGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:06:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656Ab1LPTtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:49:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:55 2011
Message-Id: <20111216194554.929957289@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wolfram Sang <w.sang@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [06/53] arm: mx23: recognise stmp378x as mx23
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit 11357be9246c7d1acf9b37ad54a18b29bbb734be upstream.

Adding the machine_is_* line was forgotten when converting mach-stmp378x to
mach-mxs.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-mxs/include/mach/mxs.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-mxs/include/mach/mxs.h
+++ b/arch/arm/mach-mxs/include/mach/mxs.h
@@ -30,6 +30,7 @@
  */
 #define cpu_is_mx23()		(					\
 		machine_is_mx23evk() ||					\
+		machine_is_stmp378x() ||				\
 		0)
 #define cpu_is_mx28()		(					\
 		machine_is_mx28evk() ||					\


