Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab1DZBAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 21:00:42 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:34244 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753268Ab1DZBAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 21:00:41 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB61913.6090907@verizon.net>
Date: Mon, 25 Apr 2011 21:00:03 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] init: change EXPERT from menuconfig to config to remove an
 empty menu
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes CONFIG_EXPERT from a menuconfig to a config
because it no longer has any child items and is therefore an empty menu.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 56240e7..332a2b3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -916,7 +916,7 @@ config SYSCTL
 config ANON_INODES
 	bool

-menuconfig EXPERT
+config EXPERT
 	bool "Configure standard kernel features (expert users)"
 	help
 	  This option allows certain base kernel options and settings
-- 
1.7.5.rc1

