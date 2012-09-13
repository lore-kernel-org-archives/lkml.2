Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab2IMSyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:54:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9505 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2IMSyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:54:13 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=iVKrcNUZX8MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6vidgQ2l4MoA:10 a=20KFwNOVAAAA:8 a=2-J6K_Kjc2weECRg5QsA:9 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120913185411.419458437@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 13 Sep 2012 14:52:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 2/2] Linux 3.0.42-rt64-rc1
References: <20120913185234.912247144@goodmis.org>
Content-Disposition: inline; filename=0002-Linux-3.0.42-rt64-rc1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

---
 localversion-rt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index b0e8dd7..c64934c 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt63
+-rt64-rc1
-- 
1.7.10.4


