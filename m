Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab1C3QTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:19:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33827 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab1C3QTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:19:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AxrQSZy/8gVjuSm5alr+dfdBdvmRc61s6t7pT3HcA8qbloIEPMekADos1VQaWwcr/a
         PtzJGeYXaKCZ3hd6HIHRNCfAu8Wg0nGFyDdCpX6uAeHi4NvhF9f2nzxmKPl4B8Rvn56S
         70n8gXShlvYsNPnc++kmmIBhkbk7S3kagcA5M=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]arch:x86:kvm:i8254.h Fix typo in kvm_pit
Date: Wed, 30 Mar 2011 09:19:02 -0700
Message-Id: <1301501942-3937-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch changes base_addresss to base_address.
Note: I have grepped for base_addresss and nothing shows up,
grepping for base_address gets me lots of output, telling me that
this is a typo, but could be wrong.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/x86/kvm/i8254.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index 46d08ca..c2fa48b 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -33,7 +33,7 @@ struct kvm_kpit_state {
 };
 
 struct kvm_pit {
-	unsigned long base_addresss;
+	unsigned long base_address;
 	struct kvm_io_device dev;
 	struct kvm_io_device speaker_dev;
 	struct kvm *kvm;
-- 
1.7.4.1

