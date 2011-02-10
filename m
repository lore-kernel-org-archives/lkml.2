Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1BJEv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 23:51:56 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47764 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab1BJEvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 23:51:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=WIrH2bnYtGWRFi0h9WiLYrTE7wBIqEoY9Wvek/ZNxC6LtXwoD1r6eebT0weUROmB9i
         7kHzNnTf+uvuvLsg3Sg4pzrSPAVlyv7fbfrtmxmwGackhFcM1Pu+no6LW6/k/UoVabr/
         XNmoA2GveLkeu8rO2ATj0URygmsqPliP2ot40=
Date: Thu, 10 Feb 2011 12:51:31 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
        davem@davemloft.net, greg@kroah.com, rdunlap@xenotime.com
Subject: [PATCH]add topgit for T: in MAINTAINERS doc.
Message-ID: <20110210045129.GA5281@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	joe@perches.com, davem@davemloft.net, greg@kroah.com,
	rdunlap@xenotime.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
     When i see MAINTAINERS, i didn't find topgit in T:. It only reads that "T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit."
     But there is topgit used in MAINTAINERS doc like following.
           
	   ARM/EZX SMARTPHONES (A780, A910, A1200, E680, ROKR E2 and ROKR E6)
	    M:      Daniel Ribeiro <drwyrm@gmail.com>
	    M:      Stefan Schmidt <stefan@openezx.org>
	    M:      Harald Welte <laforge@openezx.org>
	    L:      openezx-devel@lists.openezx.org (subscribers-only)
	    W:      http://www.openezx.org/
	    S:      Maintained
	    T:      topgit git://git.openezx.org/openezx.git      
	    F:      arch/arm/mach-pxa/ezx.c
   My patcher like following.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 95ac55c..3b4c67a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -72,7 +72,7 @@ Descriptions of section entries:
 	L: Mailing list that is relevant to this area
 	W: Web-page with status/info
 	Q: Patchwork web based patch tracking system site
-	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
+	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit, topgit.
 	S: Status, one of the following:
 	   Supported:	Someone is actually paid to look after this.
 	   Maintained:	Someone actually looks after it.
-- 
1.7.0.4


