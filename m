Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2FJRlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 13:41:00 -0400
Received: from relay01ant.iops.be ([212.53.4.34]:58497 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2FJRk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 13:40:59 -0400
Message-ID: <4FD4DC26.5080902@acm.org>
Date: Sun, 10 Jun 2012 17:40:54 +0000
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Muthu Kumar <muthu.lkml@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Jej B <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com> <4FD345DC.6020405@acm.org> <CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com>
In-Reply-To: <CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/12 23:57, Muthu Kumar wrote:

> Locking change is the one you posted already (the link above). Anyway,
> I have the attached patch *including* the locking change. Original
> mail has attachment without locking change. Please use whatever you
> need.


While we are at it ... the rq->rq_disk and rq->end_io assignments can be
performed safely before the spinlock is taken, isn't it ?

Bart.
