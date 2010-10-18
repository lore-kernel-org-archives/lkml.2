Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0JRFhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 01:37:01 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59594 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0JRFg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 01:36:59 -0400
Date: Mon, 18 Oct 2010 11:06:54 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-doc@vger.kernel.org
Cc: rdunlap@xenotime.net, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH] Fix typos in Documentation/sysctl/vm.txt
Message-ID: <20101018053654.GA14317@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fix couple of typos in Documentation/sysctl/vm.txt under
numa_zonelist_order.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
 Documentation/sysctl/vm.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index b606c2c..4de9d5b 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -477,12 +477,12 @@ the DMA zone.
 Type(A) is called as "Node" order. Type (B) is "Zone" order.
 
 "Node order" orders the zonelists by node, then by zone within each node.
-Specify "[Nn]ode" for zone order
+Specify "[Nn]ode" for node order.
 
 "Zone Order" orders the zonelists by zone type, then by node within each
-zone.  Specify "[Zz]one"for zode order.
+zone.  Specify "[Zz]one" for zone order.
 
-Specify "[Dd]efault" to request automatic configuration.  Autoconfiguration
+Specify "[Dd]efault" to request automatic configuration. Autoconfiguration
 will select "node" order in following case.
 (1) if the DMA zone does not exist or
 (2) if the DMA zone comprises greater than 50% of the available memory or
			
			Kamalesh
