Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab2JJNgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:36:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22258 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2JJNf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:35:27 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=cFxfNATEjRAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6vidgQ2l4MoA:10 a=20KFwNOVAAAA:8 a=2-J6K_Kjc2weECRg5QsA:9 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121010133524.084047489@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 10 Oct 2012 09:34:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 8/8] Linux 3.4.13-rt22-rc1
References: <20121010133406.053812290@goodmis.org>
Content-Disposition: inline; filename=0008-Linux-3.4.13-rt22-rc1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

---
 localversion-rt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index 6c6cde1..e0a34f0 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt21
+-rt22-rc1
-- 
1.7.10.4


