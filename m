Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2LLAsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:48:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab2LLAsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:48:22 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=e_QEEM34-L0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=6vidgQ2l4MoA:10 a=20KFwNOVAAAA:8 a=D2OmlHMUNEsKZPHV-1kA:9 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121212004820.743265229@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 11 Dec 2012 19:45:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 2/2] Linux 3.4.22-rt34-rc1
References: <20121212004557.110050982@goodmis.org>
Content-Disposition: inline; filename=0002-Linux-3.4.22-rt34-rc1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

---
 localversion-rt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/localversion-rt b/localversion-rt
index e1d8362..c2c1097 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt33
+-rt34-rc1
-- 
1.7.10.4


