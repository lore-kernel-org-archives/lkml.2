Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab1JZISx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 04:18:53 -0400
Received: from brick.kernel.dk ([87.104.106.3]:39566 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab1JZISw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 04:18:52 -0400
Message-ID: <4EA7C265.3030808@kernel.dk>
Date: Wed, 26 Oct 2011 10:18:45 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
        hch@infradead.org, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] block: add blk_queue_dead()
References: <1319590927-15791-1-git-send-email-tj@kernel.org> <1319590927-15791-5-git-send-email-tj@kernel.org>
In-Reply-To: <1319590927-15791-5-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-26 03:02, Tejun Heo wrote:
> There are a number of QUEUE_FLAG_DEAD tests.  Add blk_queue_dead()
> macro and use it.
> 
> This patch doesn't introduce any functional difference.

Applied 4-6 as well, thanks!

-- 
Jens Axboe

