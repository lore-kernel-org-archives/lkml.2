Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1GNOup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 10:50:45 -0400
Received: from mail.cs.hut.fi ([130.233.192.7]:36055 "EHLO mail.cs.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787Ab1GNOun convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 10:50:43 -0400
X-Greylist: delayed 2079 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jul 2011 10:50:43 EDT
From: Jaakko =?iso-8859-1?q?Kantoj=E4rvi?= <jaakko@cs.hut.fi>
Organization: Aalto - SS - CSE
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sys/time.h missing from linux/raid/pq.h for userspace builds
Date: Thu, 14 Jul 2011 17:15:17 +0300
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107141715.17770.jaakko@cs.hut.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I beleave this is required to build linux/raid/pq.h for userspace

--- /usr/src/linux-headers-2.6.39-2-common/include/linux/raid/pq.h        2011-05-19 07:06:34.000000000 +0300
+++ /usr/src/linux-headers-2.6.39-2-common/include/linux/raid/pq.h        2011-07-14 17:10:33.000000000 +0300
@@ -35,6 +35,7 @@
 #include <limits.h>
 #include <stddef.h>
 #include <sys/mman.h>
+#include <sys/time.h>
 #include <sys/types.h>
 
 /* Not standard, but glibc defines it */


I bleave this "bug" is still in git.

--
Jaakko Kantojärvi

System Admin
Department of Computer Science and Engineering
School of Science
Aalto University
