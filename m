Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab2HWGJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:09:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40995 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab2HWGJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:09:26 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: rob@landley.net, linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] documentation: virtual: Fix typo in Documentations/virtual
Date: Thu, 23 Aug 2012 15:09:19 +0900
Message-Id: <1345702159-9178-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.12.rc3.4.g91e4bfe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling typo in Documentations/virtual

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/virtual/kvm/api.txt     | 6 +++---
 Documentation/virtual/virtio-spec.txt | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index a37ec45..50c217e 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1666,7 +1666,7 @@ The parameter is defined like this:
 
 This ioctl maps the memory at "user_addr" with the length "length" to
 the vcpu's address space starting at "vcpu_addr". All parameters need to
-be alligned by 1 megabyte.
+be aligned by 1 megabyte.
 
 
 4.66 KVM_S390_UCAS_UNMAP
@@ -1686,7 +1686,7 @@ The parameter is defined like this:
 
 This ioctl unmaps the memory in the vcpu's address space starting at
 "vcpu_addr" with the length "length". The field "user_addr" is ignored.
-All parameters need to be alligned by 1 megabyte.
+All parameters need to be aligned by 1 megabyte.
 
 
 4.67 KVM_S390_VCPU_FAULT
@@ -1920,7 +1920,7 @@ be OR'ed into the "vsid" argument of the slbmte instruction.
 The "enc" array is a list which for each of those segment base page
 size provides the list of supported actual page sizes (which can be
 only larger or equal to the base page size), along with the
-corresponding encoding in the hash PTE. Similarily, the array is
+corresponding encoding in the hash PTE. Similarly, the array is
 8 entries sorted by increasing sizes and an entry with a "0" shift
 is an empty entry and a terminator:
 
diff --git a/Documentation/virtual/virtio-spec.txt b/Documentation/virtual/virtio-spec.txt
index 0d6ec85..260e384 100644
--- a/Documentation/virtual/virtio-spec.txt
+++ b/Documentation/virtual/virtio-spec.txt
@@ -1389,7 +1389,7 @@ segmentation, if both guests are amenable.
 
 Packets are transmitted by placing them in the transmitq, and
 buffers for incoming packets are placed in the receiveq. In each
-case, the packet itself is preceeded by a header:
+case, the packet itself is preceded by a header:
 
 struct virtio_net_hdr {
 
@@ -1631,7 +1631,7 @@ struct virtio_net_ctrl_mac {
 
 The device can filter incoming packets by any number of
 destination MAC addresses.[footnote:
-Since there are no guarentees, it can use a hash filter
+Since there are no guarantees, it can use a hash filter
 orsilently switch to allmulti or promiscuous mode if it is given
 too many addresses.
 ] This table is set using the class VIRTIO_NET_CTRL_MAC and the
@@ -1822,7 +1822,7 @@ the FLUSH and FLUSH_OUT types are equivalent, the device does not
 distinguish between them
 ]). If the device has VIRTIO_BLK_F_BARRIER feature the high bit
 (VIRTIO_BLK_T_BARRIER) indicates that this request acts as a
-barrier and that all preceeding requests must be complete before
+barrier and that all preceding requests must be complete before
 this one, and all following requests must not be started until
 this is complete. Note that a barrier does not flush caches in
 the underlying backend device in host, and thus does not serve as
@@ -2135,7 +2135,7 @@ This is historical, and independent of the guest page size
 
   Otherwise, the guest may begin to re-use pages previously given
     to the balloon before the device has acknowledged their
-    withdrawl. [footnote:
+    withdrawal. [footnote:
 In this case, deflation advice is merely a courtesy
 ]
 
-- 
1.7.12.rc3.4.g91e4bfe

