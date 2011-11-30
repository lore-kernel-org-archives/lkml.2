Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1K3Nzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:55:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1K3Nza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:55:30 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH 0/2] virtio-scsi driver
Date: Wed, 30 Nov 2011 14:54:57 +0100
Message-Id: <1322661299-28855-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the first version of the driver for the virtio-scsi.  It
implements a subset of the spec, in particular it does not implement
asynchronous notifications for either LUN reset/removal/addition or
CD-ROM media events.

Other matching bits:

- spec at http://people.redhat.com/pbonzini/virtio-spec.pdf (and just
  sent out)

- QEMU implementation at git://github.com/bonzini/qemu.git,
  branch virtio-scsi

Please review.

Paolo Bonzini (2):
  virtio-scsi: first version
  virtio-scsi: add error handling

 drivers/scsi/Kconfig       |    8 +
 drivers/scsi/Makefile      |    1 +
 drivers/scsi/virtio_scsi.c |  551 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio_ids.h |    1 +
 4 files changed, 561 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/virtio_scsi.c

-- 
1.7.7.1

