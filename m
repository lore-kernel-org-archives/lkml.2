Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1EEVJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 17:09:00 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57369 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab1EEVI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 17:08:59 -0400
Message-ID: <4DC311E3.8090203@kernel.dk>
Date: Thu, 05 May 2011 15:08:51 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Remove 'plug/unplug' comment in blk_execute_rq_nowait.
References: <1303746918-11097-1-git-send-email-tm@tao.ma> <4DC2C963.3040502@tao.ma>
In-Reply-To: <4DC2C963.3040502@tao.ma>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-05 09:59, Tao Ma wrote:
> Jens,
> 	Is it ok to be merged?

Yes, I will merge it in. I'll change the wording a little bit, it should
be 'run' not 'runned'.


-- 
Jens Axboe

