Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab1DYXxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 19:53:00 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:43031 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932157Ab1DYXw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 19:52:59 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB60932.6090000@verizon.net>
Date: Mon, 25 Apr 2011 19:52:18 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <gregkh@suse.de>, <hjanssen@microsoft.com>, <haiyangz@microsoft.com>
Subject: [PATCH] staging: hv: make HYPERV_UTILS depend on NLS to prevent a
 build error
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a dependency on NLS to HYPERV_UTILS to avoid a build error.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 drivers/staging/hv/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
index d41f380..76f0756 100644
--- a/drivers/staging/hv/Kconfig
+++ b/drivers/staging/hv/Kconfig
@@ -31,7 +31,7 @@ config HYPERV_NET
  config HYPERV_UTILS
 	tristate "Microsoft Hyper-V Utilities driver"
-	depends on CONNECTOR
+	depends on CONNECTOR && NLS
 	default HYPERV
 	help
 	  Select this option to enable the Hyper-V Utilities.
-- 
1.7.5.rc1

