Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2JDW7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:59:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab2JDW7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 18:59:50 -0400
Date: Thu, 4 Oct 2012 18:59:43 -0400
From: Dave Jones <davej@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: virtio build breakage.
Message-ID: <20121004225943.GA32483@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After linking, I see this..

ERROR: "virtqueue_kick" [net/9p/9pnet_virtio.ko] undefined!
ERROR: "virtqueue_get_buf" [net/9p/9pnet_virtio.ko] undefined!
ERROR: "virtqueue_add_buf" [net/9p/9pnet_virtio.ko] undefined!
ERROR: "virtqueue_notify" [drivers/scsi/virtio_scsi.ko] undefined!
ERROR: "virtqueue_kick_prepare" [drivers/scsi/virtio_scsi.ko] undefined!
ERROR: "virtqueue_kick" [drivers/scsi/virtio_scsi.ko] undefined!
ERROR: "virtqueue_add_buf" [drivers/scsi/virtio_scsi.ko] undefined!
ERROR: "virtqueue_enable_cb" [drivers/scsi/virtio_scsi.ko] undefined!
ERROR: "virtqueue_get_buf" [drivers/scsi/virtio_scsi.ko] undefined!
ERROR: "virtqueue_disable_cb" [drivers/scsi/virtio_scsi.ko] undefined!
ERROR: "vring_del_virtqueue" [drivers/remoteproc/remoteproc.ko] undefined!
ERROR: "vring_new_virtqueue" [drivers/remoteproc/remoteproc.ko] undefined!
ERROR: "vring_interrupt" [drivers/remoteproc/remoteproc.ko] undefined!
ERROR: "vring_transport_features" [drivers/remoteproc/remoteproc.ko] undefined!
ERROR: "virtqueue_enable_cb_delayed" [drivers/net/virtio_net.ko] undefined!
ERROR: "virtqueue_enable_cb" [drivers/net/virtio_net.ko] undefined!
ERROR: "virtqueue_kick" [drivers/net/virtio_net.ko] undefined!
ERROR: "virtqueue_add_buf" [drivers/net/virtio_net.ko] undefined!
ERROR: "virtqueue_disable_cb" [drivers/net/virtio_net.ko] undefined!
ERROR: "virtqueue_get_buf" [drivers/net/virtio_net.ko] undefined!
ERROR: "virtqueue_detach_unused_buf" [drivers/net/virtio_net.ko] undefined!
ERROR: "virtqueue_get_vring_size" [drivers/net/virtio_net.ko] undefined!
ERROR: "virtqueue_disable_cb" [drivers/char/virtio_console.ko] undefined!
ERROR: "virtqueue_detach_unused_buf" [drivers/char/virtio_console.ko] undefined!
ERROR: "virtqueue_kick" [drivers/char/virtio_console.ko] undefined!
ERROR: "virtqueue_add_buf" [drivers/char/virtio_console.ko] undefined!
ERROR: "virtqueue_get_buf" [drivers/char/virtio_console.ko] undefined!
ERROR: "virtqueue_kick" [drivers/char/hw_random/virtio-rng.ko] undefined!
ERROR: "virtqueue_add_buf" [drivers/char/hw_random/virtio-rng.ko] undefined!
ERROR: "virtqueue_get_buf" [drivers/char/hw_random/virtio-rng.ko] undefined!
ERROR: "virtqueue_kick" [drivers/block/virtio_blk.ko] undefined!
ERROR: "virtqueue_add_buf" [drivers/block/virtio_blk.ko] undefined!
ERROR: "virtqueue_get_buf" [drivers/block/virtio_blk.ko] undefined!

config is at http://fpaste.org/svfL/raw

	Dave

