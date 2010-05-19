Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab0ESPvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:51:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab0ESPu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:50:59 -0400
From: Jes.Sorensen@redhat.com
To: rusty@rustcorp.com.au
Cc: mst@redhat.com, linux-kernel@vger.kernel.org,
       Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH] virtio_blk.c: Add documentation for vring_enable_cb()
Date: Wed, 19 May 2010 17:50:48 +0200
Message-Id: <1274284249-29398-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This patch adds a bit of documentation to vring_enable_cb() to make it
crystal clear that the function returns false when there is more work
to do and true when the queue is empty.

I wasted several hours trying to figure out why a piece of code wasn't
working due to this, and I know others hit the same problem. Hopefully
this can save a bit of suffering for others in the future.

Cheers,
Jes


Jes Sorensen (1):
  Add documentation for vring_enable_cb()

 drivers/virtio/virtio_ring.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

