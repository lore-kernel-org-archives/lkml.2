Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab2H1L7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:59:36 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56188 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2H1L7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:59:34 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, jbottomley@parallels.com
Subject: [PATCH for 3.6 0/3] urgent virtio-scsi fixes
Date: Tue, 28 Aug 2012 13:59:11 +0200
Message-Id: <1346155154-12915-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

here are three important bugfixes for virtio-scsi.  All three have been
on the list for a while, I'm grouping them in this post to ease your
processing.

Two of them are also marked for stable branches.

Paolo

Paolo Bonzini (1):
  virtio-scsi: fix LUNs greater than 255

Richard W.M. Jones (1):
  virtio-scsi: initialize scatterlist structure for events

Wang Sen (1):
  virtio-scsi: fix copying of sg_list in the presence of of HighMem pages

 drivers/scsi/virtio_scsi.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

