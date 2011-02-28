Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab1B1TZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:25:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab1B1TZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:25:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com, neilb@suse.de
Subject: [PATCH 0/3] block: Few fixes for throttle and blk_cleanup_queue() 
Date: Mon, 28 Feb 2011 14:25:27 -0500
Message-Id: <1298921130-17533-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

These are few fixes for block throtl code and for blk_cleanup_queue(). These
should be a good candidate for 2.6.39.

Please let me know if you have any concerns.

Thanks
Vivek

Vivek Goyal (3):
  block: Initialize ->queue_lock to internal lock at queue allocation
    time
  loop: No need to initialize ->queue_lock explicitly before calling
    blk_cleanup_queue()
  block: Move blk_throtl_exit() call to blk_cleanup_queue()

 block/blk-core.c       |   23 +++++++++++++++++++++--
 block/blk-settings.c   |    7 -------
 block/blk-sysfs.c      |    2 --
 block/blk-throttle.c   |    6 +++---
 drivers/block/loop.c   |    3 ---
 include/linux/blkdev.h |    2 --
 6 files changed, 24 insertions(+), 19 deletions(-)

-- 
1.7.2.3

