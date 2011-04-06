Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1DFJK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:10:27 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:40030 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1DFJK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:10:26 -0400
Subject: [PATCH] [TRIVIAL] Documentation: fix 3 typos in sysctl/vm.txt
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 06 Apr 2011 11:09:55 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.92 (2.91.92-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1302081025.1923.26.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/sysctl/vm.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 30289fa..96f0ee8 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -481,10 +481,10 @@ the DMA zone.
 Type(A) is called as "Node" order. Type (B) is "Zone" order.
 
 "Node order" orders the zonelists by node, then by zone within each node.
-Specify "[Nn]ode" for zone order
+Specify "[Nn]ode" for node order
 
 "Zone Order" orders the zonelists by zone type, then by node within each
-zone.  Specify "[Zz]one"for zode order.
+zone.  Specify "[Zz]one" for zone order.
 
 Specify "[Dd]efault" to request automatic configuration.  Autoconfiguration
 will select "node" order in following case.
-- 
1.7.4.1



