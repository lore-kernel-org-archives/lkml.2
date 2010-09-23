Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab0IWREv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 13:04:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab0IWREs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 13:04:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] MN10300: Arch doesn't support HAVE_ARCH_TRACEHOOK
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>, David Howells <dhowells@redhat.com>
Date: Thu, 23 Sep 2010 18:04:33 +0100
Message-ID: <20100923170433.7022.56090.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100923170428.7022.35221.stgit@warthog.procyon.org.uk>
References: <20100923170428.7022.35221.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

Remove specification of HAVE_ARCH_TRACEHOOK for MN10300 as the arch does not
support it at this time.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 444b9f9..7c2a2f7 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -8,7 +8,6 @@ mainmenu "Linux Kernel Configuration"
 config MN10300
 	def_bool y
 	select HAVE_OPROFILE
-	select HAVE_ARCH_TRACEHOOK
 
 config AM33
 	def_bool y

