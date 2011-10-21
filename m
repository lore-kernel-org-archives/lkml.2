Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110Ab1JUEDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 00:03:22 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58186 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1JUEDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 00:03:21 -0400
Message-ID: <4EA0EF06.3090508@pobox.com>
Date: Fri, 21 Oct 2011 00:03:18 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, vgoyal@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 1/6] block, sx8: kill blk_insert_request()
References: <1319169400-15706-1-git-send-email-tj@kernel.org> <1319169400-15706-2-git-send-email-tj@kernel.org>
In-Reply-To: <1319169400-15706-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2011 11:56 PM, Tejun Heo wrote:
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

Acked-by: Jeff Garzik <jgarzik@redhat.com>



