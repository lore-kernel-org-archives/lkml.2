Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab0GEGzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 02:55:40 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54708 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab0GEGzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 02:55:39 -0400
Message-ID: <4C3181E8.8010802@kernel.dk>
Date: Mon, 05 Jul 2010 08:55:36 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] remove q->prepare_flush_fn hook
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-03 10:45, FUJITA Tomonori wrote:
> This removes q->prepare_flush_fn. Except for ide and scsi, all the
> users just mark flush requests. They can use REQ_FLUSH flag
> instead.
> 
> SCSI and ide can use q->prep_rq_fn to build flush requests.
> 
> This can be applied to the block's for-2.6.36.

Thanks, applied.

-- 
Jens Axboe

