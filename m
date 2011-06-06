Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab1FFN4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:56:13 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45566 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab1FFN4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:56:07 -0400
Date: Mon, 06 Jun 2011 09:56:01 -0400
Message-Id: <E1QTaHh-00048w-Qn@tytso-glaptop>
To: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: checkpatch gives false positives for include/trace/events/*.h
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The format used for trace/events/*.h files makes checkpatch very
unhappy.

Fortunately the trivial patch brigade haven't (yet) started sending
pointless patches to fix checkpatch "errors".

						- Ted

ERROR: space prohibited after that open parenthesis '('
#64: FILE: include/trace/events/ext4.h:29:
+		__field(	__u64, blocks			)

ERROR: space prohibited before that close parenthesis ')'
#64: FILE: include/trace/events/ext4.h:29:
+		__field(	__u64, blocks			)

ERROR: space prohibited after that open parenthesis '('
#224: FILE: include/trace/events/ext4.h:649:
+		__field(	__u32,  logical			)

ERROR: space prohibited before that close parenthesis ')'
#224: FILE: include/trace/events/ext4.h:649:
+		__field(	__u32,  logical			)

ERROR: space prohibited after that open parenthesis '('
#225: FILE: include/trace/events/ext4.h:650:
+		__field(	__u32,	lleft			)

ERROR: space prohibited before that close parenthesis ')'
#225: FILE: include/trace/events/ext4.h:650:
+		__field(	__u32,	lleft			)

ERROR: space prohibited after that open parenthesis '('
#226: FILE: include/trace/events/ext4.h:651:
+		__field(	__u32,	lright			)

ERROR: space prohibited before that close parenthesis ')'
#226: FILE: include/trace/events/ext4.h:651:
+		__field(	__u32,	lright			)

ERROR: space prohibited after that open parenthesis '('
#262: FILE: include/trace/events/ext4.h:690:
+		__field(	__u32,  logical			)

ERROR: space prohibited before that close parenthesis ')'
#262: FILE: include/trace/events/ext4.h:690:
+		__field(	__u32,  logical			)

ERROR: space prohibited after that open parenthesis '('
#263: FILE: include/trace/events/ext4.h:691:
+		__field(	__u32,	lleft			)

ERROR: space prohibited before that close parenthesis ')'
#263: FILE: include/trace/events/ext4.h:691:
+		__field(	__u32,	lleft			)

ERROR: space prohibited after that open parenthesis '('
#264: FILE: include/trace/events/ext4.h:692:
+		__field(	__u32,	lright			)

ERROR: space prohibited before that close parenthesis ')'
#264: FILE: include/trace/events/ext4.h:692:
+		__field(	__u32,	lright			)

ERROR: space prohibited after that open parenthesis '('
#300: FILE: include/trace/events/ext4.h:730:
+		__field(	umode_t, mode			)

ERROR: space prohibited before that close parenthesis ')'
#300: FILE: include/trace/events/ext4.h:730:
+		__field(	umode_t, mode			)

ERROR: space prohibited after that open parenthesis '('
#304: FILE: include/trace/events/ext4.h:733:
+		__field(	int,	flags			)

ERROR: space prohibited before that close parenthesis ')'
#304: FILE: include/trace/events/ext4.h:733:
+		__field(	int,	flags			)

ERROR: space prohibited after that open parenthesis '('
#420: FILE: include/trace/events/ext4.h:1288:
+		__field(	unsigned int,	blocks		)

ERROR: space prohibited before that close parenthesis ')'
#420: FILE: include/trace/events/ext4.h:1288:
+		__field(	unsigned int,	blocks		)

ERROR: space prohibited after that open parenthesis '('
#460: FILE: include/trace/events/ext4.h:1363:
+		__field(	__u64,		blocks		)

ERROR: space prohibited before that close parenthesis ')'
#460: FILE: include/trace/events/ext4.h:1363:
+		__field(	__u64,		blocks		)

ERROR: space prohibited after that open parenthesis '('
#491: FILE: include/trace/events/ext4.h:1401:
+		__field(	unsigned int,	len		)

ERROR: space prohibited before that close parenthesis ')'
#491: FILE: include/trace/events/ext4.h:1401:
+		__field(	unsigned int,	len		)

ERROR: space prohibited after that open parenthesis '('
#492: FILE: include/trace/events/ext4.h:1402:
+		__field(	unsigned int,	flags		)

ERROR: space prohibited before that close parenthesis ')'
#492: FILE: include/trace/events/ext4.h:1402:
+		__field(	unsigned int,	flags		)

ERROR: space prohibited after that open parenthesis '('
#519: FILE: include/trace/events/ext4.h:1444:
+		__field(	unsigned int,	len		)

ERROR: space prohibited before that close parenthesis ')'
#519: FILE: include/trace/events/ext4.h:1444:
+		__field(	unsigned int,	len		)

total: 28 errors, 0 warnings, 468 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
