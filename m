Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0KWNj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:39:57 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:49226 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab0KWNjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:39:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sG4SxiBQGcfa+RuFcW3/wQbNPR+Nex6ULCB/xPdJ1qwUxx4GVGxSRtgToYfrzgsvOx
         D+TC7bUk4CdvzjVb5w3caR0v1Hw9aMIljW/5d1I2mk6mhhWoXTXys3PpYfuEcO5KBB3h
         020IaSpaSOlcx+0ymFC0opzmstb0sFzE02grI=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3 09/22] kvm: stop including asm-generic/bitops/le.h
Date: Tue, 23 Nov 2010 22:38:11 +0900
Message-Id: <1290519504-3958-10-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
References: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
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
index da16155..57a7e3d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,7 +52,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm-generic/bitops/le.h>
 
 #include "coalesced_mmio.h"
 
-- 
1.7.3.2

