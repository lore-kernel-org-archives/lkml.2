Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1LFUvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:51:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47262 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab1LFUvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:51:19 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] KVM: Document KVM_NMI
Date: Tue,  6 Dec 2011 22:50:43 +0200
Message-Id: <1323204643-17373-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 Documentation/virtual/kvm/api.txt |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 7945b0b..0b7b8f2 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1450,6 +1450,19 @@ is supported; 2 if the processor requires all virtual machines to have
 an RMA, or 1 if the processor can use an RMA but doesn't require it,
 because it supports the Virtual RMA (VRMA) facility.
 
+4.64 KVM_NMI
+
+Capability: basic
+Architectures: none
+Type: vcpu ioctl
+Parameters: none
+Returns: 0 on success, -1 on error
+
+Trigger an NMI on the specified VCPU.
+
+This can be used to cause a panic in the guest, which in turn would result
+in a backtrace/dump.
+
 5. The kvm_run structure
 
 Application code obtains a pointer to the kvm_run structure by
-- 
1.7.8

