Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0DCJ5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 05:57:15 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4441 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab0DCJ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 05:57:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] lib/vsprintf.c: Add missing EXPORT_SYMBOL(simple_strtoll)
Date: Sat, 3 Apr 2010 11:57:36 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-tschai; KDE/4.3.5; x86_64; ; )
Cc: andre.goddard@gmail.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004031157.36191.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple patch to fix a missing EXPORT_SYMBOL.

I must be the first person that wants to use this function :-)

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 24112e5..fe5ea4e 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -118,6 +118,7 @@ long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 
 	return simple_strtoull(cp, endp, base);
 }
+EXPORT_SYMBOL(simple_strtoll);
 
 /**
  * strict_strtoul - convert a string to an unsigned long strictly

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
