Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0GZUnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:43:15 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:50781 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab0GZUnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:43:13 -0400
Date: Mon, 26 Jul 2010 22:43:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] frv: remove useless ARCHMODFLAGS assignment
Message-ID: <20100726204312.GB18853@merkur.ravnborg.org>
References: <20100726203814.GA18828@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726203814.GA18828@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e72470f99bad5a3d1632e738cdf884bfc2d8687f Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 26 Jul 2010 22:11:36 +0200
Subject: [PATCH 2/3] frv: remove useless ARCHMODFLAGS assignment

There is no references to ARCHMODLFAGS throughout the kernel tree.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/Makefile |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/frv/Makefile b/arch/frv/Makefile
index 310c47a..018455e 100644
--- a/arch/frv/Makefile
+++ b/arch/frv/Makefile
@@ -36,8 +36,6 @@ else
 UTS_SYSNAME = -DUTS_SYSNAME=\"uClinux\"
 endif
 
-ARCHMODFLAGS	+= -G0 -mlong-calls
-
 ifdef CONFIG_GPREL_DATA_8
 KBUILD_CFLAGS	+= -G8
 else
-- 
1.6.0.6

