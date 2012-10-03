Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2JCU5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:57:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab2JCU5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:57:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com, jmoyer@redhat.com, tj@kernel.org
Subject: [PATCH 0/6] cfq-iosched: Some minor cleanups
Date: Wed,  3 Oct 2012 16:56:55 -0400
Message-Id: <1349297821-30078-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I posted CFQ changes for changing scheduling algorithm for cfq queues.
There were few small cleanups/renaming patches. I have pulled out
these patches from that series and posting these separately. There
is no functionality change.

Will post scheduling algorithm changes in a separate series on
top of this series.

I have taken care of comments from last posting and also included
the ACKs.

Thanks
Vivek

Vivek Goyal (6):
  cfq-iosched: Properly name all references to IO class
  cfq-iosched: More renaming to better represent wl_class and wl_type
  cfq-iosched: Rename "service_tree" to "st" at some places
  cfq-iosched: Rename few functions related to selecting workload
  cfq-iosched: Get rid of unnecessary local variable
  cfq-iosched: Print sync-noidle information in blktrace messages

 block/cfq-iosched.c |  177 +++++++++++++++++++++++++--------------------------
 1 files changed, 88 insertions(+), 89 deletions(-)

-- 
1.7.7.6

