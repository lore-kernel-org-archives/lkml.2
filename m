Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1FIBDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 21:03:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41409 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1FIBDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 21:03:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VO6y497QPXLjBamhU3/TRJqmJoXYTDB4jV5LTPv3DKwc9iH7nJjOuManl9rlvOhC9K
         juQHb0I6h6zWUUVjCils7Sjnq1hDDMvZRxuDNkAnqKF3VUwdz7cKsnw1GNDLU3v21cuY
         PvPzWvUzs4s3dwGK/g65IX5jh5+TqVG3qecJE=
From: Wu DaoGuang <wdgvip@gmail.com>
To: ben-linux@fluff.org, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wdgvip@gmail.com
Subject: [PATCH 2/4] This patch fixes Makefile for mach-ok2440.c
Date: Thu,  9 Jun 2011 09:03:20 +0800
Message-Id: <1307581402-3808-2-git-send-email-wdgvip@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307581402-3808-1-git-send-email-wdgvip@gmail.com>
References: <1307581402-3808-1-git-send-email-wdgvip@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for ok2440 development board.

The following patches are against v3.0-rc2.

Signed-off-by: Wu DaoGuang <wdgvip@gmail.com>
---
 arch/arm/mach-s3c2440/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2440/Makefile b/arch/arm/mach-s3c2440/Makefile
index d5440fa..da4ad71 100644
--- a/arch/arm/mach-s3c2440/Makefile
+++ b/arch/arm/mach-s3c2440/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_MACH_ANUBIS)	+= mach-anubis.o
 obj-$(CONFIG_MACH_OSIRIS)	+= mach-osiris.o
 obj-$(CONFIG_MACH_RX3715)	+= mach-rx3715.o
 obj-$(CONFIG_ARCH_S3C2440)	+= mach-smdk2440.o
+obj-$(CONFIG_MACH_OK2440)	+= mach-ok2440.o
 obj-$(CONFIG_MACH_NEXCODER_2440) += mach-nexcoder.o
 obj-$(CONFIG_MACH_AT2440EVB) += mach-at2440evb.o
 obj-$(CONFIG_MACH_MINI2440) += mach-mini2440.o
-- 
1.7.1

