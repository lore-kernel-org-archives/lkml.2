Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab1ANXtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:49:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:34924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab1ANXta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:49:30 -0500
Date: Fri, 14 Jan 2011 23:49:14 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@redhat.com, dsd@laptop.org, dilinger@queued.net,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, dsd@laptop.org, dilinger@queued.net,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100923162846.D8D409D401B@zog.reactivated.net>
References: <20100923162846.D8D409D401B@zog.reactivated.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, olpc: Add missing Kconfig dependencies
Message-ID: <tip-76d1f7bfcd5872056902c5a88b5fcd5d4d00a7a9@git.kernel.org>
Git-Commit-ID: 76d1f7bfcd5872056902c5a88b5fcd5d4d00a7a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 14 Jan 2011 23:49:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76d1f7bfcd5872056902c5a88b5fcd5d4d00a7a9
Gitweb:     http://git.kernel.org/tip/76d1f7bfcd5872056902c5a88b5fcd5d4d00a7a9
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 14 Jan 2011 11:57:06 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jan 2011 11:57:06 -0800

x86, olpc: Add missing Kconfig dependencies

OLPC uses select for OLPC_OPENFIRMWARE, which means OLPC has to
enforce the dependencies for OLPC_OPENFIRMWARE.  Make sure it does so.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
LKML-Reference: <20100923162846.D8D409D401B@zog.reactivated.net>
Cc: <stable@kernel.org> 2.6.37
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b6fccb0..184bc88 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2064,6 +2064,7 @@ config OLPC
 	bool "One Laptop Per Child support"
 	select GPIOLIB
 	select OLPC_OPENFIRMWARE
+	depends on !X86_64 && !X86_PAE
 	---help---
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
