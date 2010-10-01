Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0JATRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 15:17:15 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35311 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab0JATRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 15:17:14 -0400
Message-ID: <4CA633B6.2000905@kernel.dk>
Date: Fri, 01 Oct 2010 21:17:10 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] blkio-throttle: Few more cleanup and fixes
References: <1285950029-30205-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1285950029-30205-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-01 18:20, Vivek Goyal wrote:
> Hi Jens,
> 
> There are 3 more cleanups and fixes for blkio throttle. Nothing major, just
> that while scanning the code and while doing some testing I found good to
> have fixes. Please apply.
> 
> [PATCH 1/3] blkio-throttle: There is no need to convert jiffies to milli seconds
> [PATCH 2/3] blkio-throttle: limit max iops value to UINT_MAX
> [PATCH 3/3] blkio-throttle: Fix possible multiplication overflow in iops calculations

Added, thanks Vivek.

-- 
Jens Axboe

