Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2DAVeC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:34:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33923 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab2DAVeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:34:00 -0400
Message-ID: <4F78C9C3.3090203@kernel.dk>
Date: Sun, 01 Apr 2012 14:33:55 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] block: Make cfq_target_latency tunable through
 sysfs.
References: <1332836213-5266-1-git-send-email-tm@tao.ma> <1333207867-2957-1-git-send-email-tm@tao.ma>
In-Reply-To: <1333207867-2957-1-git-send-email-tm@tao.ma>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-31 08:31, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In cfq, when we calculate a time slice for a process(or a cfqq to
> be precise), we have to consider the cfq_target_latency so that all the
> sync request have an estimated latency(300ms) and it is controlled by
> cfq_target_latency. But in some hadoop test, we have found that if
> there are many processes doing sequential read(24 for example), the
> throughput is bad because every process can only work for about 25ms
> and the cfqq is switched. That leads to a higher disk seek. We can
> achive the good throughput by setting low_latency=0, but then some
> read's latency is too much for the application.
> 
> So this patch makes cfq_target_latency tunable through sysfs so that
> we can tune it and find some magic number which is not bad for both
> the throughput and the read latency.

Thanks, applied both.

-- 
Jens Axboe

