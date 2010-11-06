Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab0KFFBQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 01:01:16 -0400
Received: from nm3-vm0.bullet.mail.sp2.yahoo.com ([98.139.90.230]:20073 "HELO
	nm3-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751359Ab0KFFBN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 01:01:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 823995.43277.bm@omp1036.mail.sp2.yahoo.com
Message-ID: <516164.25539.qm@web110514.mail.gq1.yahoo.com>
X-YMail-OSG: dyUbAZsVM1mRnv3zsi2.x7P7SUwn5Gg4yyfdlmIR97_enr.
 S1bB1IQMAqmxq0iBa18UyEPJMn0uEl7C4sgBSuxFYf1hdBtTkMvJixaBt3mK
 zxzXjE1CMgPM1xQB.5APGZ17xOf7bJ2dIPv7vLBGLRuVW88FxRRSQW3ixywK
 MYiepDun2y51oJnIvWG3_5CeRHkw1UdGZrxqo5yOmvzii9VGZf8ZTf8HH0Gp
 KsSib4FZ6Va8V96.2PqNAVH0vkQ3KgOkJpLnTDPstmWXXjfjNS8hK1aC7h_I
 B4MoOpQJ8gDzlkCUZ0c86UJsJXXEPWqAorLYeLPfMWYkrDqipvsHFcwGSEhj
 8WA8we8V_1PDAIJRIdrINM0cLLXZ1FsSDPgauL_il
X-RocketYMMF: multiplicador
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Fri, 5 Nov 2010 22:01:11 -0700 (PDT)
From: =?iso-8859-1?Q?Andr=E9_Luis_Pereira_dos_Santos_-_BSRSoft?= 
	<andre@bsrsoft.com.br>
Reply-To: andre@bsrsoft.com.br
Subject: [PATCH 1/1] virt: ack_flush() function removed for lack of apparent use 2.6.37-rc1
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Ack_flush function () is not used anywhere in the code and apparently has no function currently defined.

Unless there are plans to use it in the future, I took it out via this patch code for readability.



Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
---
Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
--- linux-2.6.37-rc1/virt/kvm/kvm_main.c	2010-11-01 09:54:12.000000000 -0200
+++ linux-2.6.37-rc1-patched/virt/kvm/kvm_main.c	2010-11-06 02:43:56.000000000 -0200
@@ -132,9 +132,6 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 	mutex_unlock(&vcpu->mutex);
 }
 
-static void ack_flush(void *_completed)
-{
-}
 
 static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {


      
