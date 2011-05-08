Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab1EHHzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 03:55:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42473 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751330Ab1EHHza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 03:55:30 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX1+MqiFZWraMFqVDgBMUSt87Sots4MZlxA1pXrz50w
	aLa7+n+Z2tHjQM
From: Emil Langrock <emil.langrock@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: checkpatch "unclean" patches
Date: Sun, 8 May 2011 09:55:26 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-2-amd64; KDE/4.6.2; x86_64; ; )
Cc: Andy Whitcroft <apw@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105080955.27160.emil.langrock@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wanted to send some patches, but checkpatch always tells me that they arent
clean and that I should fix them... but I am sure that the checkpatch.pl is
wrong.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ERROR: need consistent spacing around '*' (ctx:WxV)
#70: FILE: abc.h:70:
+	struct xyz __rcu *bar;
 	                 ^

CHECK: spinlock_t definition without comment
#92: FILE: abc.h:92:
+	spinlock_t foo; /* protects: bar, foobar, barfoo, kaazaa, flupflup, fafafa,

total: 1 errors, 0 warnings, 1 checks, 1337 lines checked
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I am quite sure that the spacing should not be "struct xyz __rcu * bar" and
that the thing behind "spinlock_t foo;" is a comment.

Should I fix my patches or should checkpatch.pl be fixed?
-- 
Emil Langrock
