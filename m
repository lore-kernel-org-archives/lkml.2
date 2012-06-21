Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab2FUA4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:56:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37469 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab2FUA4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:56:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAFR8ueeFcnMCqG=A1im09crBNckgfPixsCz9oceQCpPeJ3wiNw@mail.gmail.com>
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com>
	<4FD345DC.6020405@acm.org>
	<CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com>
	<4FD4DC26.5080902@acm.org>
	<CAFR8uecF0LwbV8FvYob5m34sVbKqafrNoYOrcRUQCEOymGnYRA@mail.gmail.com>
	<CAFR8uefK+nByiJ8tw5_KF1qEJs4du2mDdU36gg1_2nRNZXN5Fw@mail.gmail.com>
	<20120618224253.GH32733@google.com>
	<4FE21C15.6040409@acm.org>
	<CAFR8ueeFcnMCqG=A1im09crBNckgfPixsCz9oceQCpPeJ3wiNw@mail.gmail.com>
Date: Wed, 20 Jun 2012 17:56:36 -0700
X-Google-Sender-Auth: Zo0b9lrXwnTbyIjp2ZucE4hcdFI
Message-ID: <CAOS58YPiPK-p3dPRb9jLY0H8cKFT-RxaU4LkuMF0XHEVMLyLBw@mail.gmail.com>
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
From: Tejun Heo <tj@kernel.org>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
        Jej B <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 20, 2012 at 5:53 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Reported-by: Muthukumar Ratty <muthur@gmail.com>
>
> Hmm... Shouldn't this be:
>
> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> Tested-by: Bart Van Assche <bvanassche@acm.org>

Yeah and From: tag at the beginning too. Bart?

Thanks.

-- 
tejun
