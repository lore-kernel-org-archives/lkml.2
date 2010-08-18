Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab0HRGoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:44:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49335 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0HRGoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:44:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=kV0BSNNpBR95jl4MOCX5fD49KCwaOtO6o5sQWcWOLWWkYfko271lkgz7ZyQM1iMJll
         Qd7G+DefRWEworQT3P5K8/IZmsU4YwrxtbvtUjLIy3JAfryvs0p1tC/oFiBg2EPzpC2L
         veFVKq8E6hCmJGRqIhhwzjXvitAM9YLENbQQw=
Date: Wed, 18 Aug 2010 14:48:28 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, nhorman@redhat.com
Subject: [Patch] vmcore: it is not experimental any more
Message-ID: <20100818064817.GA5676@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We use vmcore in our production kernel for a long time,
it is pretty stable now. So I don't think we need to mark
it as experimental any more.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 50f8f06..3df4257 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -33,7 +33,7 @@ config PROC_KCORE
 	depends on PROC_FS && MMU
 
 config PROC_VMCORE
-        bool "/proc/vmcore support (EXPERIMENTAL)"
+        bool "/proc/vmcore support"
         depends on PROC_FS && CRASH_DUMP
 	default y
         help
