Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0FYTzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:55:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61524 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0FYTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:55:53 -0400
MIME-Version: 1.0
Date: Fri, 25 Jun 2010 14:55:51 -0500
X-Google-Sender-Auth: _XNnDna7wrBvJ9na9tX2lnkebek
Message-ID: <AANLkTikLs62R7V4YE-1VHUYpGEa0Zjlg39PUMplJvhUM@mail.gmail.com>
Subject: [PATCH] Add missing part of vgaarb.h include guard
From: Doug Goldstein <cardoe@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: vignatti@freedesktop.org, przanoni@gmail.com, benh@kernel.crashing.org,
       airlied@linux.ie
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vgaarb.h was missing the #define of the #ifndef at the top for the guard
to prevent multiple #include's from causing re-define errors

Signed-off-by: Doug Goldstein <cardoe@gentoo.org>
---
 include/linux/vgaarb.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index c9a9759..814f294 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -29,6 +29,7 @@
  */

 #ifndef LINUX_VGA_H
+#define LINUX_VGA_H

 #include <asm/vga.h>

-- 
1.7.1
