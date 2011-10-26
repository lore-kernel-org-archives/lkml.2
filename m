Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab1JZINO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 04:13:14 -0400
Received: from brick.kernel.dk ([87.104.106.3]:39482 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142Ab1JZINM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 04:13:12 -0400
Message-ID: <4EA7C0D5.7020406@kernel.dk>
Date: Wed, 26 Oct 2011 10:12:05 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
        hch@infradead.org, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] block, sx8: kill blk_insert_request()
References: <1319590927-15791-1-git-send-email-tj@kernel.org> <1319590927-15791-2-git-send-email-tj@kernel.org>
In-Reply-To: <1319590927-15791-2-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-26 03:02, Tejun Heo wrote:
> The only user left for blk_insert_request() is sx8 and it can be
> trivially switched to use blk_execute_rq_nowait() - special requests
> aren't included in io stat and sx8 doesn't use block layer tagging.
> Switch sx8 and kill blk_insert_requeset().
> 
> This patch doesn't introduce any functional difference.

Applied.

-- 
Jens Axboe

