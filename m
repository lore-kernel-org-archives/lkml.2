Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab0JUOn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:43:56 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36696 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0JUOnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YIz1O4MvCIaLM7U/IYt3c8uN1dflcUMR0h5y98RRL1cTRRHIH23hDZW86pWBsfsdyb
         gHnY0KJw6Oq3MMCk+C17KTGo6E1wG77XSCiDkwsJJLbg77de3d7O0ENK2hb7asr7n1GW
         m5uVDHAnn/+sWKwf4+gAOrn7Nb0Abb8CrdiTM=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 09/22] kvm: stop including asm-generic/bitops/le.h
Date: Thu, 21 Oct 2010 23:41:04 +0900
Message-Id: <1287672077-5797-10-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to include asm-generic/bitops/le.h as all architectures
provide little-endian bit operations now.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org
---
No change from previous submission

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

