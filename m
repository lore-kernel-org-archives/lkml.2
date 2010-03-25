Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab0CYRZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:25:21 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35786 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0CYRXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=mt3IUtXwQKJapJ7YIvf2UG7FDWOl9x49uhrlV/Htdqox53Grdv2r/LzWhl+aMRvmyn
         02Moe+FRqbCVZGhELHSzjfqIzMistDKVEqoC4S/H++lHa2iRpk9DHTwEQsUGlEUkFNUf
         E9p3K5bLLJTFBMIT+q38WN6h4sf/W9mchuRYQ=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       Ben Hutchings <ben@decadent.org.uk>, Joe Perches <joe@perches.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/16] Staging: sep: sep_driver.c: duplicated include
Date: Thu, 25 Mar 2010 18:22:38 +0100
Message-Id: <1269537767-7553-8-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/sep/sep_driver.c: linux/sched.h is included more than once.

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 drivers/staging/sep/sep_driver.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 265de79..9be1fb7 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -39,7 +39,6 @@
 #include <linux/mm.h>
 #include <linux/poll.h>
 #include <linux/wait.h>
-#include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/firmware.h>
 #include <asm/ioctl.h>
-- 
1.7.0.3.296.g9776a

