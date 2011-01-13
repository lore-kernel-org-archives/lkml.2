Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab1AMXWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 18:22:54 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42197 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340Ab1AMXWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 18:22:48 -0500
Date: Thu, 13 Jan 2011 15:22:39 -0800
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Michael Neuling <mikey@neuling.org>,
        Grant Likely <grant.likely@secretlab.ca>, sonnyrao@us.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pseries_defconfig: add BNX2=m
Message-ID: <20110113232239.GA4277@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.6.35-24-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upcoming servers will include a Broadcom NIC, add to the defconfig to
increase testing coverage and make sure mainline builds come up with
networking.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index f87f0e1..2048585 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -184,6 +184,7 @@ CONFIG_ACENIC_OMIT_TIGON_I=y
 CONFIG_E1000=y
 CONFIG_E1000E=y
 CONFIG_TIGON3=y
+CONFIG_BNX2=m
 CONFIG_CHELSIO_T1=m
 CONFIG_CHELSIO_T3=m
 CONFIG_EHEA=y


-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
