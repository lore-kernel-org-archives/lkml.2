Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab1BJJzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:55:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:57377 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab1BJJzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:55:00 -0500
Message-Id: <b9dded$htd8nk@orsmga002.jf.intel.com>
Date: 10 Feb 2011 01:54:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'";a="601268990"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david@woodhou.se, david.woodhouse@intel.com
Subject: [RFC PATCH 01/13] Intel(R) MEI Driver
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index b7980a8..0a54b26 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -1144,5 +1144,16 @@ config RAMOOPS
 	  This enables panic and oops messages to be logged to a circular
 	  buffer in RAM where it can be read back at some later point.
 
+config INTEL_MEI
+	tristate "Intel(R) Management Engine Interface (Intel(R) MEI)"
+	default m
+	depends on EXPERIMENTAL && X86
+	help
+	  If you have an Intel(R) ME chip in your system 
+	  say Yes to enable the Intel(R) Managment Engine interface.
+	  for more informaiton see
+	  <http://software.intel.com/en-us/manageability/>
+
+
 endmenu
 


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

