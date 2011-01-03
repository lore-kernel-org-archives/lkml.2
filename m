Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab1ACN7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:59:00 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39265 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab1ACN67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:58:59 -0500
Message-ID: <4D21D67C.50704@kernel.dk>
Date: Mon, 03 Jan 2011 15:00:28 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/32] block: make kblockd_workqueue smarter
References: <1294062595-30097-1-git-send-email-tj@kernel.org> <1294062595-30097-4-git-send-email-tj@kernel.org>
In-Reply-To: <1294062595-30097-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-03 14:49, Tejun Heo wrote:
> kblockd is used for unplugging and may affect IO latency and
> throughput and the max number of concurrent work items are bound by
> the number of block devices.  Make it HIGHPRI workqueue w/ default max
> concurrency.

Thanks Tejun, I've pulled the two into the 2.6.38 tree.

-- 
Jens Axboe

