Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1KXLJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:09:40 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43576 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1KXLJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:09:38 -0500
MIME-Version: 1.0
From: Rahul Bedarkar <rpal143@gmail.com>
Date: Thu, 24 Nov 2011 16:39:17 +0530
Message-ID: <CA+NV+Vkog3M6BMC9iMAdCJPbsDQUvPJx1ucsX5FV=kHJLu+ryw@mail.gmail.com>
Subject: [path] adding header info in raw.h
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

    Adding header info in raw.h

[master 1e3c43b] Added info header in raw.h 1 files changed, 6
insertions(+), 0 deletions(-)


diff --git a/include/linux/raw.h b/include/linux/raw.h
index 62d543e..7ca527a 100644
--- a/include/linux/raw.h
+++ b/include/linux/raw.h
@@ -1,3 +1,9 @@
+/*
+* include/linux/raw.h
+*
+* include file for raw block device drivers
+*/
+
 #ifndef __LINUX_RAW_H
 #define __LINUX_RAW_H


Regards,
Rahul Bedarkar
