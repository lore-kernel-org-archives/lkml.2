Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab2JBP0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:26:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38698 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2JBP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:26:04 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Subject: [PATCH 0/3] virtio-scsi updates for 3.7
Date: Tue,  2 Oct 2012 17:25:45 +0200
Message-Id: <1349191548-7120-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James, here is a resend of the three pending patches for
virtio-scsi, with the bugfix first.

Thanks,

Paolo

Paolo Bonzini (2):
  virtio-scsi: fix LUNs greater than 255
  virtio-scsi: support online resizing of disks

Richard W.M. Jones (1):
  virtio-scsi: initialize scatterlist structure

 drivers/scsi/virtio_scsi.c  |   39 ++++++++++++++++++++++++++++++++++++---
 include/linux/virtio_scsi.h |    2 ++
 2 files changed, 38 insertions(+), 3 deletions(-)

