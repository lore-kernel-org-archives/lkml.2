Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0JVSdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:33:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43781 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721Ab0JVSYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=u/CQVZBEaASGyN8VOqWkmGCfGTE/QYWhiHJIEt1L58TUSTE7Tv3CExCIgTiNVmmMR5
         PctUOkyz8Y8a/CLjev/5/nIaCMEFhK8TP3hyo7wMP9hPfRnZiWNin0zAFALP4ysqg08L
         EBJMEnUO9emR7rtknkHcD8H25XZ9u1rO9Bp9M=
Message-ID: <4CC1D6EA.5060002@gmail.com>
Date: Fri, 22 Oct 2010 20:24:42 +0200
From: "N.P.S." <napohybelskurwysynom2010@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC][PATCH 6/8] Removal of dead code from arch/powerpc/kernel/process.c
References: <4CC1D2D5.9050009@gmail.com>
In-Reply-To: <4CC1D2D5.9050009@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 12747993cb2b4a07df7a62f247f20aa4a6263cd9
Author: N.P.S <napohybelskurwysynom2010@gmail.com>
Date:   Thu Oct 21 23:36:00 2010 +0200

    Removal of dead code from
    arch/powerpc/kernel/process.c
    
    Signed-off-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
    CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    CC: Paul Mackerras <paulus@samba.org>
    CC: <linuxppc-dev@lists.ozlabs.org>
    CC: <linux-kernel@vger.kernel.org>

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index b1c648a..e622887 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -670,12 +670,7 @@ void exit_thread(void)
 void flush_thread(void)
 {
 	discard_lazy_cpu_state();
-
-#ifdef CONFIG_HAVE_HW_BREAKPOINTS
-	flush_ptrace_hw_breakpoint(current);
-#else /* CONFIG_HAVE_HW_BREAKPOINTS */
 	set_debug_reg_defaults(&current->thread);
-#endif /* CONFIG_HAVE_HW_BREAKPOINTS */
 }
 
 void
