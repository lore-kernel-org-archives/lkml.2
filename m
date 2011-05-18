Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772Ab1ERTbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:31:01 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54572 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933756Ab1ERTa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:30:59 -0400
Message-ID: <4DD41E71.6080103@kernel.dk>
Date: Wed, 18 May 2011 21:30:57 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: namhyung@gmail.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, James.Bottomley@suse.de
Subject: Re: [PATCH 1/3] bsg: fix bsg_poll() to return POLLOUT properly
References: <1305437513-3914-1-git-send-email-namhyung@gmail.com> <20110519.030933.1568838937885764850.fujita.tomonori@lab.ntt.co.jp@lab.ntt.co.jp>
In-Reply-To: <20110519.030933.1568838937885764850.fujita.tomonori@lab.ntt.co.jp@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-18 20:09, FUJITA Tomonori wrote:
> On Sun, 15 May 2011 14:31:51 +0900
> Namhyung Kim <namhyung@gmail.com> wrote:
> 
>> POLLOUT should be returned only if bd->queued_cmds < bd->max_queue
>> so that bsg_alloc_command() can proceed.
>>
>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
>> ---
>>  block/bsg.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> All the three patches look good.
> 
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

You can add mine, too.

Acked-by: Jens Axboe <jaxboe@fusionio.com>

-- 
Jens Axboe

