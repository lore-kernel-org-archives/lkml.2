Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0L3EDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 23:03:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:38162 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab0L3EC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 23:02:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=DT9C0g1qjPVoW5ZvM6+Ty8PRADOuXAhqQpIViEqmUaI/Te/RmW4EtaVzoMo5lfyWlp
         Gb95DpzLWB1U1v1hir8w==
Date: Wed, 29 Dec 2010 20:02:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 7/8] lib: rename CONFIG_EMBEDDED to CONFIG_EXPERT
In-Reply-To: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1012292001430.27241@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_EMBEDDED has been renamed to CONFIG_EXPERT, so fix it in the lib/
directory.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 lib/Kconfig.debug |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -656,7 +656,7 @@ config DEBUG_HIGHMEM
 	  Disable for production systems.
 
 config DEBUG_BUGVERBOSE
-	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EMBEDDED
+	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
 	depends on BUG
 	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
 		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300
@@ -728,8 +728,8 @@ config DEBUG_WRITECOUNT
 	  If unsure, say N.
 
 config DEBUG_MEMORY_INIT
-	bool "Debug memory initialisation" if EMBEDDED
-	default !EMBEDDED
+	bool "Debug memory initialisation" if EXPERT
+	default !EXPERT
 	help
 	  Enable this for additional checks during memory initialisation.
 	  The sanity checks verify aspects of the VM such as the memory model
