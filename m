Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2A3PAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:00:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab2A3PAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:00:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: tj@kernel.org, sjayaraman@suse.com, gouders@et.bocholt.fh-gelsenkirchen.de,
        vgoyal@redhat.com
Subject: [PATCH 0/2] floppy: Fix couple of crashes during init and module removal
Date: Mon, 30 Jan 2012 09:59:49 -0500
Message-Id: <1327935591-26812-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Here are couple of fixes for floppy driver. These fixes need to go in for 3.3.
Original discussion thread is here.

https://lkml.org/lkml/2012/1/24/138

I am reposting the patches in a separate thread as it might be easier for you
to pick up the patches.

Thanks
Vivek

Vivek Goyal (2):
  floppy: Cleanup disk->queue before caling put_disk() if add_disk()
    was never called
  floppy: Fix a crash during rmmod

 drivers/block/floppy.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

-- 
1.7.4.4

