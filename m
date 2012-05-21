Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab2EUUuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:50:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480Ab2EUUuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:50:11 -0400
Date: Mon, 21 May 2012 13:49:59 -0700
From: tip-bot for Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Message-ID: <tip-b2d668da9307c4c163dd603d2bb3cadb10f9fd37@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jarkko.sakkinen@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jarkko.sakkinen@intel.com
In-Reply-To: <1337622684-6834-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1337622684-6834-1-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, relocs: Build clean fix
Git-Commit-ID: b2d668da9307c4c163dd603d2bb3cadb10f9fd37
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 13:50:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2d668da9307c4c163dd603d2bb3cadb10f9fd37
Gitweb:     http://git.kernel.org/tip/b2d668da9307c4c163dd603d2bb3cadb10f9fd37
Author:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>
AuthorDate: Mon, 21 May 2012 20:51:24 +0300
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 21 May 2012 12:19:37 -0700

x86, relocs: Build clean fix

relocs was not cleaned up when "make clean" is issued. This
patch fixes the issue.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1337622684-6834-1-git-send-email-jarkko.sakkinen@intel.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@vger.kernel.org> v3.4

---
 arch/x86/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 94e91e4..b1c611e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -206,6 +206,7 @@ archclean:
 	$(Q)rm -rf $(objtree)/arch/i386
 	$(Q)rm -rf $(objtree)/arch/x86_64
 	$(Q)$(MAKE) $(clean)=$(boot)
+	$(Q)$(MAKE) $(clean)=arch/x86/tools
 
 define archhelp
   echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
