Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938Ab2JXAxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:53:09 -0400
Received: from mailserver6.natinst.com ([130.164.80.6]:44363 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407Ab2JXAxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:53:08 -0400
Date: Tue, 23 Oct 2012 19:53:06 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm: l2cc: doc: fix device tree example typo
Message-ID: <20121024005306.GA32126@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 07:53:01 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/23/2012 07:53:01 PM,
	Serialize complete at 10/23/2012 07:53:01 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-23_09:2012-10-23,2012-10-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list of attributes above details the use of the 'filter-ranges'
property, but the example improperly used 'filter-latency'.  Make these
consistent by fixing up the example.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 Documentation/devicetree/bindings/arm/l2cc.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
index 7ca5216..7c3ee3a 100644
--- a/Documentation/devicetree/bindings/arm/l2cc.txt
+++ b/Documentation/devicetree/bindings/arm/l2cc.txt
@@ -37,7 +37,7 @@ L2: cache-controller {
         reg = <0xfff12000 0x1000>;
         arm,data-latency = <1 1 1>;
         arm,tag-latency = <2 2 2>;
-        arm,filter-latency = <0x80000000 0x8000000>;
+        arm,filter-ranges = <0x80000000 0x8000000>;
         cache-unified;
         cache-level = <2>;
 	interrupts = <45>;
-- 
1.8.0
