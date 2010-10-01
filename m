Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab0JAQUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:20:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab0JAQUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:20:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com
Subject: [PATCH 0/3] blkio-throttle: Few more cleanup and fixes 
Date: Fri,  1 Oct 2010 12:20:26 -0400
Message-Id: <1285950029-30205-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

There are 3 more cleanups and fixes for blkio throttle. Nothing major, just
that while scanning the code and while doing some testing I found good to
have fixes. Please apply.

[PATCH 1/3] blkio-throttle: There is no need to convert jiffies to milli seconds
[PATCH 2/3] blkio-throttle: limit max iops value to UINT_MAX
[PATCH 3/3] blkio-throttle: Fix possible multiplication overflow in iops calculations

Thanks
Vivek
