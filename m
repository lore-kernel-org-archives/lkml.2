Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1EHVSs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 17:18:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33879 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab1EHVSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 17:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UaqIpZ/6dp37J4pNPidUdRuzI8HQdsdNg/G56KAdAnkO+t8vnsBoZV+87/F9oVYWSa
         dH9ylb64qB7ayxfMReA+WrhqPv3JNQy8nHVR4g2OvS/305xTJyCKw2pZ3QKVF3hOq7M3
         oQP9kZn/+8HfSQ75QSf1eAEJAZdSV7Wxgv6m0=
Date: Mon, 9 May 2011 00:18:34 +0300
From: Maxin B John <maxin.john@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, riel@redhat.com, walken@google.com,
        aarcange@redhat.com, hughd@google.com, linux-mm@kvack.org
Subject: [PATCH] mm: memory: remove unreachable code
Message-ID: <20110508211834.GA4410@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unreachable code found in mm/memory.c

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/mm/memory.c b/mm/memory.c
index 27f4253..d3b30af 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3695,7 +3695,6 @@ static int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 			if (ret <= 0)
 #endif
 				break;
-			bytes = ret;
 		} else {
 			bytes = len;
 			offset = addr & (PAGE_SIZE-1);
