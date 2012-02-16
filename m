Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2BPN4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:56:03 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:51465 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870Ab2BPN4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:56:00 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Avi Kivity <avi@redhat.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch/powerpc/kvm/book3s_hv.c: included linux/sched.h twice
Date: Thu, 16 Feb 2012 14:55:54 +0100
Message-Id: <1329400554-31904-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329400560;b12fe983;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/powerpc/kvm/book3s_hv.c: included 'linux/sched.h' twice,
remove the duplicate.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/powerpc/kvm/book3s_hv.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 336983d..a726716 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -46,7 +46,6 @@
 #include <asm/page.h>
 #include <asm/hvcall.h>
 #include <linux/gfp.h>
-#include <linux/sched.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
 
-- 
1.7.8.3

