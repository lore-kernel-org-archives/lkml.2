Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2HYDSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 23:18:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31688 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2HYDQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 23:16:59 -0400
X-Authority-Analysis: v=2.0 cv=cpwZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Pj3ZmwIWgjcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=GrsrJ4PtYi8A:10 a=meVymXHHAAAA:8 a=XPGjAnsNJBQewrkO2B0A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120825031657.992174759@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 24 Aug 2012 23:12:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 2/2] Linux 3.2.27-rt41-rc1
References: <20120825031219.772181128@goodmis.org>
Content-Disposition: inline; filename=0002-Linux-3.2.27-rt41-rc1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 localversion-rt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index 629e0b4..31c892a 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt41
+-rt42-rc1
-- 
1.7.10.4


