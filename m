Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964971Ab2CVJrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 05:47:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab2CVJrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 05:47:00 -0400
Subject: [PATCH] virtio-spec: fix typo
To: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 22 Mar 2012 17:46:47 +0800
Message-ID: <20120322094647.26280.72051.stgit@jason-ThinkPad-T400>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 virtio-0.9.4.lyx |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/virtio-0.9.4.lyx b/virtio-0.9.4.lyx
index 6c7bab1..9d30977 100644
--- a/virtio-0.9.4.lyx
+++ b/virtio-0.9.4.lyx
@@ -58,6 +58,7 @@
 \html_be_strict false
 \author -608949062 "Rusty Russell,,," 
 \author 1531152142 "pbonzini" 
+\author 2090695081 "Jason" 
 \end_header
 
 \begin_body
@@ -4657,9 +4658,14 @@ Control Virtqueue
 \end_layout
 
 \begin_layout Standard
-The driver uses the control virtqueue (if VIRTIO_NET_F_VTRL_VQ is negotiated)
- to send commands to manipulate various features of the device which would
- not easily map into the configuration space.
+The driver uses the control virtqueue (if VIRTIO_NET_F_
+\change_inserted 2090695081 1332409259
+C
+\change_deleted 2090695081 1332409259
+V
+\change_unchanged
+TRL_VQ is negotiated) to send commands to manipulate various features of
+ the device which would not easily map into the configuration space.
 \end_layout
 
 \begin_layout Standard

