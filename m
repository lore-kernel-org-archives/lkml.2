Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab0HEDha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:37:30 -0400
Received: from ozlabs.org ([203.10.76.45]:41614 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758684Ab0HEDh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:37:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] virtio
Date: Thu, 5 Aug 2010 13:07:25 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ryan Harper <ryanh@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008051307.26111.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3cfc2c42c1cbc8e238bb9c0612c0df4565e3a8b4:
  Linus Torvalds (1):
        Merge branch 'for-next' of git://git.kernel.org/.../jikos/trivial

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git virtio

Christoph Hellwig (1):
      virtio_blk: support barriers without FLUSH feature

Ryan Harper (2):
      virtio_blk: Add 'serial' attribute to virtio-blk devices (v2)
      virtio_blk: Remove VBID ioctl

 drivers/block/virtio_blk.c |   64 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 51 insertions(+), 13 deletions(-)
