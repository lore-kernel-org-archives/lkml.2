Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab2FNPuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:50:50 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61219 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab2FNPut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:50:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120613191801.GC8230@kernel.dk>
References: <1339088835-2614-1-git-send-email-glorioustao@gmail.com> <20120613191801.GC8230@kernel.dk>
From: Tao Guo <glorioustao@gmail.com>
Date: Thu, 14 Jun 2012 23:50:26 +0800
Message-ID: <CAAV8rn+zRrA67eRkpycygnnasKwrhMW=AjCEvEGFuzX7MfFxWQ@mail.gmail.com>
Subject: Re: [PATCH V2] umem: fix up unplugging
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Shaohua Li <shli@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jens. I can do that for 3.6 kernel.
-Tao

On Thu, Jun 14, 2012 at 3:18 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On Thu, Jun 07 2012, Tao Guo wrote:
>> Fix a regression introduced by 7eaceaccab5f40 ("block: remove per-queue
>> plugging").  In that patch, Jens removed the whole mm_unplug_device()
>> function, which used to be the trigger to make umem start to work.
>>
>> We need to implement unplugging to make umem start to work, or I/O will
>> never be triggered.
>
> Applied this one, dropped the other two. Would still be nice to move
> this generic functionality into the block core and unify md/umem in this
> regard for 3.6, if you would like to do that.
>
> --
> Jens Axboe
>
