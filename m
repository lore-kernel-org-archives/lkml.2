Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab1FOBZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:25:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:57493 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab1FOBZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:25:25 -0400
Date: Wed, 15 Jun 2011 01:25:04 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Message-ID: <tip-4b9c25fcf748c37e0a3e5dfe918b2120d601e492@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tony.luck@intel.com, bp@amd64.org, tglx@linutronix.de,
        hpa@linux.intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, hpa@linux.intel.com,
        bp@amd64.org, mingo@elte.hu
In-Reply-To: <1308067734-6156-1-git-send-email-bp@amd64.org>
References: <1308067734-6156-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, MAINTAINERS: Add x86 RAS people
Git-Commit-ID: 4b9c25fcf748c37e0a3e5dfe918b2120d601e492
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Jun 2011 01:25:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b9c25fcf748c37e0a3e5dfe918b2120d601e492
Gitweb:     http://git.kernel.org/tip/4b9c25fcf748c37e0a3e5dfe918b2120d601e492
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Tue, 14 Jun 2011 18:08:54 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 14 Jun 2011 18:14:26 -0700

x86, MAINTAINERS: Add x86 RAS people

Announce the new RAS infrastructure maintainers. The file patterns below
will change after we start the restructuring.

Signed-off-by: Borislav Petkov <bp@amd64.org>
Link: http://lkml.kernel.org/r/1308067734-6156-1-git-send-email-bp@amd64.org
Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e50fc6e..e33b1b8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6994,6 +6994,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.
 S:	Maintained
 F:	drivers/platform/x86
 
+X86 RAS INFRASTRUCTURE
+M:	Tony Luck <tony.luck@intel.com>
+M:	Borislav Petkov <bp@amd64.org>
+L:	linux-edac@vger.kernel.org
+S:	Maintained
+F:	arch/x86/kernel/cpu/mcheck/*
+
 XEN HYPERVISOR INTERFACE
 M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
 M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
