Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0JOJso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 05:48:44 -0400
Received: from [150.82.175.143] ([150.82.175.143]:47239 "EHLO
	dhcpa11143.tky.aist.go.jp" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755275Ab0JOJod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 05:44:33 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 09/22] kvm: stop including asm-generic/bitops/le.h
Date: Fri, 15 Oct 2010 18:46:08 +0900
Message-Id: <1287135981-17604-10-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-Reply-To: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to include asm-generic/bitops/le.h as all architectures
provide little endian bit operations now.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org
---
 virt/kvm/kvm_main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2d9927c..e5d190f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,7 +52,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm-generic/bitops/le.h>
 
 #include "coalesced_mmio.h"
 
-- 
1.7.1.231.gd0b16

