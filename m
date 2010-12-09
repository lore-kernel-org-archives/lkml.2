Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab0LIPLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:11:45 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:36848 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab0LIPLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:11:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wb/QUdClI33YP5ZX5P4j0QKL0FSjnqxNQGjml1aH7vhMitbUkd+io+Y14mtKisMlVt
         T71pWauzoFT1rd43Afsw0dwvDY1I1+TxP6MuzCb/sZkjjtZT3u5cfx8ED3jttlNA9WSc
         iTHrUcf/7ajRe1hQA9YX1TF3RdEswDUy+A25s=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 7/8] staging: ft1000: Remove dead code.
Date: Thu,  9 Dec 2010 16:13:53 +0100
Message-Id: <1291907634-22437-7-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
References: <1291907634-22437-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index bd28a6b..da706f8 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -27,11 +27,7 @@
 	len += snprintf(page+len, PAGE_SIZE - len, "%d\n", var[i])
 
 
-//#ifdef INIT_NET_NS
 #define FTNET_PROC init_net.proc_net
-//#else
-//#define FTNET_PROC proc_net
-//#endif
 
 
 u16 ft1000_read_dpram16 (struct ft1000_device *ft1000dev, u16 indx,
-- 
1.7.1

