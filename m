Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab0IBVOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:14:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59003 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab0IBVOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vCQ/XKFHlW2vfN0dhF5ZntMmBzcF/MDVPzoSvPOZZShqZyso/yiSVuq5HquFaCs92P
         laf4EbXySAJtk6mwCH/Q9AkPMoOe1JClhzefFDcSaUKreHHEKfpqpQLjc43TwaGJcjMp
         D+ehGSwFU8mBnmCUG4bgnIkZ49Z2OZMwrRcSs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 85/91] arch/um/os-Linux/start_up.c Update broken web addresses in the arch directory.
Date: Thu,  2 Sep 2010 14:13:36 -0700
Message-Id: <1283462022-8024-10-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283462022-8024-1-git-send-email-justinmattock@gmail.com>
References: <1283462022-8024-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/um/os-Linux/start_up.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index 02ee9ad..48bbefa 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -195,7 +195,7 @@ __uml_setup("nosysemu", nosysemu_cmd_param,
 "    SYSEMU is a performance-patch introduced by Laurent Vivier. It changes\n"
 "    behaviour of ptrace() and helps reducing host context switch rate.\n"
 "    To make it working, you need a kernel patch for your host, too.\n"
-"    See http://perso.wanadoo.fr/laurent.vivier/UML/ for further \n"
+"    See http://web.archive.org/web/*/http://perso.wanadoo.fr/laurent.vivier/UML/ for further \n"
 "    information.\n\n");
 
 static void __init check_sysemu(void)
-- 
1.7.2.1

