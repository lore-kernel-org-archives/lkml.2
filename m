Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1JZBTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:19:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48830 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab1JZBTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:19:05 -0400
Message-ID: <4EA76006.7020901@pobox.com>
Date: Tue, 25 Oct 2011 21:19:02 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, vgoyal@redhat.com, davem@davemloft.net, hch@infradead.org,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] block, sx8: kill blk_insert_request()
References: <1319590927-15791-1-git-send-email-tj@kernel.org> <1319590927-15791-2-git-send-email-tj@kernel.org>
In-Reply-To: <1319590927-15791-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 09:02 PM, Tejun Heo wrote:
> The only user left for blk_insert_request() is sx8 and it can be
> trivially switched to use blk_execute_rq_nowait() - special requests
> aren't included in io stat and sx8 doesn't use block layer tagging.
> Switch sx8 and kill blk_insert_requeset().
>
> This patch doesn't introduce any functional difference.
>
> Only compile tested.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Jeff Garzik<jgarzik@pobox.com>
> Cc: Jens Axboe<axboe@kernel.dk>

As before,

Acked-by: Jeff Garzik <jgarzik@redhat.com>



