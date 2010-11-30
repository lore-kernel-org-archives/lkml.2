Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab0K3Q4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:56:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab0K3Qz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:55:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com, jmoyer@redhat.com, oleg@redhat.com, jmarchan@redhat.com
Subject: [PATCH 0/2] blk-throttle: Couple of small fixes
Date: Tue, 30 Nov 2010 11:55:55 -0500
Message-Id: <1291136157-2732-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

During some testing and discussions with Oleg, two bugs were noticed with
block throttle code. Please find attached the fixes. These are small fixes
and I did not notice any side affects during my testing.

Thanks
Vivek

Vivek Goyal (2):
  blk-throttle: Trim/adjust slice_end once a bio has been dispatched
  blk-throttle: Correct the placement of smp_rmb()

 block/blk-throttle.c |   39 +++++++++++++++++++++++++--------------
 1 files changed, 25 insertions(+), 14 deletions(-)

-- 
1.7.2.3

