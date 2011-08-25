Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1HYWht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 18:37:49 -0400
Received: from natasha.panasas.com ([67.152.220.90]:50255 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab1HYWhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 18:37:48 -0400
Message-ID: <4E56CE8F.8080501@panasas.com>
Date: Thu, 25 Aug 2011 15:37:03 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Git Mailing List <git@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] .gitattributes: Enable cpp diff parsing for .[ch] files
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The Linux Kernel source tree is certainly a C language repository.
As a maintainer and code reviewer I would like too, for example:
See function names as hunk headers and not goto labels. And all
the other goodies a language specific diff parser gives me.

Add a .gitattributes file to the Linux tree to enable cpp parsing
of the source files.

People are welcome to add other parsers for other type of files
if needed. (Like Makefile or Kconfig ...)

CC: Jeff King <peff@peff.net>
CC: Junio C Hamano <gitster@pobox.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 .gitattributes |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
 create mode 100644 .gitattributes

diff --git a/.gitattributes b/.gitattributes
new file mode 100644
index 0000000..6d2b620
--- /dev/null
+++ b/.gitattributes
@@ -0,0 +1,2 @@
+*.h diff=cpp
+*.c diff=cpp
-- 
1.7.6

