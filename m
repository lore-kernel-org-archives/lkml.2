Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403Ab2FGJOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:14:54 -0400
Received: from nm3.access.bullet.mail.sp2.yahoo.com ([98.139.44.130]:32977
	"HELO nm3.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760308Ab2FGJOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:14:52 -0400
X-Yahoo-Newman-Id: 482651.44941.bm@omp1016.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: CEYNlWsVM1le05vyupLc3U5Bu5.MLzn1EEtS3iodFX_t7zX
 e6kGNZrAXNqA0a.7f5FYhxpfBtkNPsJzS_1j4QjlKzvri6xsIub15r7Neth4
 oKCVTcmpDHqiu.Vnw1nGiwQdiDRD0S9eegYRku_nxZR.ZKrrMnVDRQYS18jB
 B1KHjQ5PR6zpEgivuCN7r5NwrQIPg6G9csaN4iSACqK2D3OuhoXJPLSwZIdB
 96logD6AkmVEx9QtBCG3gIQHjLAGgc9f7DheEkxR2hVzR_2mAYQevCei10gK
 wTIJFCDXgLjP7peD68oEBvDixsCfkXzjWWJD.lw3EnNUKaFLKbwrFwxFu0pL
 HlucJJ.YRPyeMtqptnBm9bzKivhPWYCjrYRUVbn4Vc9VGBQKBv.Kl6o8e6q5
 xNsvBWA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FD0710F.1020105@att.net>
Date: Thu, 07 Jun 2012 04:14:55 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCHv3 2/6] [RFC] bug.h: Replace __linktime_error with __compiletime_error
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/bug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index aaac4bb..298a916 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -73,7 +73,7 @@ extern int __build_bug_on_failed;
 #define BUILD_BUG()						\
 	do {							\
 		extern void __build_bug_failed(void)		\
-			__linktime_error("BUILD_BUG failed");	\
+			__compiletime_error("BUILD_BUG failed");\
 		__build_bug_failed();				\
 	} while (0)
 -- 1.7.3.4

