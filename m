Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1CHOBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 09:01:51 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43186 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab1CHOBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 09:01:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=JT95iVSE6J7L9X5u3y/uuQcuWz02NMSsG+oBEuDRQ8vLVedLQewJqYO6JQQ+woaluf
         pBmTI5jCirVxLYhweJqh9zfHmtrmuORXf71EqrIR/SIlsSs+/I++A7oBKY9FHeacp7PV
         sMc6bx8uB38CPl2Z+IX0SG5qVNoBuW6Qqu1NQ=
MIME-Version: 1.0
Date: Tue, 8 Mar 2011 22:01:47 +0800
Message-ID: <AANLkTi=AdWh+oAe4ZVgUUxZffv1uHSPE3J1b8KZ=yS_7@mail.gmail.com>
Subject: [2.6.38-rc8, patch] minor ANSI prototype sparse fix
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix function prototype to be ANSI-C compliant, consistent with other
function prototypes, addressing a sparse warning.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/kernel/module.c b/kernel/module.c
index efa290e..be35185 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1627,7 +1627,7 @@ void unset_section_ro_nx(struct module *mod,
void *module_region)
 }

 /* Iterate through all modules and set each module's text as RW */
-void set_all_modules_text_rw()
+void set_all_modules_text_rw(void)
 {
 	struct module *mod;

@@ -1648,7 +1648,7 @@ void set_all_modules_text_rw()
 }

 /* Iterate through all modules and set each module's text as RO */
-void set_all_modules_text_ro()
+void set_all_modules_text_ro(void)
 {
 	struct module *mod;

-- 
Daniel J Blueman
