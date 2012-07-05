Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2GEKHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:07:25 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57754 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2GEKHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:07:23 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: amit.shah@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com
Subject: [PATCH] MAINTAINERS: add kvm list for virtio components
Date: Thu,  5 Jul 2012 12:07:07 +0200
Message-Id: <1341482827-13195-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The KVM list is followed by more people than the generic
virtualization@lists.linux-foundation.org mailing list, and is
already "de facto" the place where virtio patches are posted.

pv-ops still has no other lists than virtualization@lists.linux-foundation.org.
However, pv-ops patches will likely touch Xen or KVM files as well and
the respective mailing list will usually be reached as well.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 14bc707..e265f2e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7340,6 +7340,7 @@ F:	include/media/videobuf2-*
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit.shah@redhat.com>
 L:	virtualization@lists.linux-foundation.org
+L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/char/virtio_console.c
 F:	include/linux/virtio_console.h
@@ -7348,6 +7349,7 @@ VIRTIO CORE, NET AND BLOCK DRIVERS
 M:	Rusty Russell <rusty@rustcorp.com.au>
 M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	virtualization@lists.linux-foundation.org
+L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/virtio/
 F:	drivers/net/virtio_net.c
-- 
1.7.1

