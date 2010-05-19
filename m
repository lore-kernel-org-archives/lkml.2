Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0ESROZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:14:25 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:6099 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab0ESROY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ksrinivasan@novell.com:4:1>);
	Wed, 19 May 2010 13:14:24 -0400
Message-Id: <4BF3C35A02000030000855F1@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 19 May 2010 10:54:18 -0600
From: "Ky Srinivasan" <ksrinivasan@novell.com>
To: <hpa@zytor.com>
Cc: <greg@kroah.com>, <hjanssen@microsoft.com>, <mingo@redhat.com>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] Hyperv: Export the symbol that tracks hyperv features
	 and recommendations
References: <4BE49778.6060800@zytor.com>
 <tip-e08cae4181af9483b04ecfac48f01c8e5a5f27bf@git.kernel.org>
In-Reply-To: <tip-e08cae4181af9483b04ecfac48f01c8e5a5f27bf@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: K. Y. Srinivasan <ksrinivasan@novell.com>
Subject:  Export the symbol  for hyperv drivers to access hyperv
features and recommendations.

Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>

Index: linux.trees.git/arch/x86/kernel/cpu/mshyperv.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/cpu/mshyperv.c	2010-05-18 10:14:02.000000000 -0600
+++ linux.trees.git/arch/x86/kernel/cpu/mshyperv.c	2010-05-18 14:12:11.000000000 -0600
@@ -18,6 +18,7 @@
 #include <asm/mshyperv.h>
 
 struct ms_hyperv_info ms_hyperv;
+EXPORT_SYMBOL(ms_hyperv);
 
 static bool __init ms_hyperv_platform(void)
 {








