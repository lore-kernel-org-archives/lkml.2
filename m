Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab1GMDwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 23:52:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:37081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368Ab1GMDwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 23:52:15 -0400
Date: Wed, 13 Jul 2011 03:52:00 GMT
From: tip-bot for Darren Hart <dvhart@linux.intel.com>
Message-ID: <tip-11e48feebe8b5d2ae348893a6e0d47c46204bee2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dvhart@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <541cf88e2dfe5b8186d8b96b136d892e769a68c1.1310441260.git.dvhart@linux.intel.com>
References: <541cf88e2dfe5b8186d8b96b136d892e769a68c1.1310441260.git.dvhart@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, doc only: Correct real-mode kernel header offset for init_size
Git-Commit-ID: 11e48feebe8b5d2ae348893a6e0d47c46204bee2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jul 2011 03:52:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11e48feebe8b5d2ae348893a6e0d47c46204bee2
Gitweb:     http://git.kernel.org/tip/11e48feebe8b5d2ae348893a6e0d47c46204bee2
Author:     Darren Hart <dvhart@linux.intel.com>
AuthorDate: Mon, 11 Jul 2011 20:27:40 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Jul 2011 20:39:11 -0700

x86, doc only: Correct real-mode kernel header offset for init_size

The real-mode kernel header init_size field is located at 0x260 per the field
listing in th e"REAL-MODE KERNEL HEADER" section. It is listed as 0x25c in
the "DETAILS OF HEADER FIELDS" section, which overlaps with pref_address.
Correct the details listing to 0x260.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Link: http://lkml.kernel.org/r/541cf88e2dfe5b8186d8b96b136d892e769a68c1.1310441260.git.dvhart@linux.intel.com
CC: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/x86/boot.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 9b7221a..7c3a880 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -674,7 +674,7 @@ Protocol:	2.10+
 
 Field name:	init_size
 Type:		read
-Offset/size:	0x25c/4
+Offset/size:	0x260/4
 
   This field indicates the amount of linear contiguous memory starting
   at the kernel runtime start address that the kernel needs before it
