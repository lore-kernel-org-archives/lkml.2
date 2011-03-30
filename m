Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab1C3QzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:55:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35598 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707Ab1C3QzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:55:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Mr59omTYqlWa3Uctk8OU98NdP1hX+Q+HUpPygqq2LMQxXqclmgTNST4p6w6GVIN2ug
         +OkxfwYI619cD+VbMs4AUjjY8HXRGWzChVb/i0IyJMAOwPxoToTZLJ7UrbfOkVxeioqy
         r6yc5UbQ5a+HRzPKPpzUteK0u9jX3JAExdnb0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH v2]arch:x86:kvm:i8254.h Remove base_addresss in kvm_pit since it is unused.
Date: Wed, 30 Mar 2011 09:54:47 -0700
Message-Id: <1301504087-3266-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes unsigned long base_addresss; in i8254.h 
since it is unused.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/x86/kvm/i8254.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index 46d08ca..b681a9f 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -33,7 +33,6 @@ struct kvm_kpit_state {
 };
 
 struct kvm_pit {
-	unsigned long base_addresss;
 	struct kvm_io_device dev;
 	struct kvm_io_device speaker_dev;
 	struct kvm *kvm;
-- 
1.7.4.1

