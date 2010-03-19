Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab0CSDOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 23:14:11 -0400
Received: from mail-qy0-f182.google.com ([209.85.221.182]:61017 "EHLO
	mail-qy0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0CSDOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 23:14:09 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Mar 2010 23:14:09 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=o1RumBeJpFtdFo/l+Gyv7ZPrW0PxPScyc/Gvv5l3HifAFyzHLCqiC0O3YWM77oczlK
         9rI/WgBQBxxSsv+I9iwH+LIUn2juVPPJ3fPlRqjHUEX17n3V1zVGOmM/RrhJ28K4VA5Q
         r0PXKy50Nib7BpctleukWOdZlFVDxD1OGTZCg=
Date: Fri, 19 Mar 2010 19:05:52 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
Subject: [PATCH] Netfilter: Remove unused headers in net/ipv4/netfilter/nf_nat_h323.c
Message-ID: <20100319110552.GA3048@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused headers in net/ipv4/netfilter/nf_nat_h323.c

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 net/ipv4/netfilter/nf_nat_h323.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index ee47bf2..bf6a120 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/tcp.h>
 #include <net/tcp.h>
 
-- 
1.6.5.3

