Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2FUFkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 01:40:40 -0400
Received: from relay01ant.iops.be ([212.53.4.34]:41066 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2FUFki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 01:40:38 -0400
Message-ID: <4FE2B3D1.6070504@acm.org>
Date: Thu, 21 Jun 2012 05:40:33 +0000
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Muthu Kumar <muthu.lkml@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Jej B <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com> <4FD345DC.6020405@acm.org> <CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com> <4FD4DC26.5080902@acm.org> <CAFR8uecF0LwbV8FvYob5m34sVbKqafrNoYOrcRUQCEOymGnYRA@mail.gmail.com> <CAFR8uefK+nByiJ8tw5_KF1qEJs4du2mDdU36gg1_2nRNZXN5Fw@mail.gmail.com> <20120618224253.GH32733@google.com> <4FE21C15.6040409@acm.org> <CAFR8ueeFcnMCqG=A1im09crBNckgfPixsCz9oceQCpPeJ3wiNw@mail.gmail.com>
In-Reply-To: <CAFR8ueeFcnMCqG=A1im09crBNckgfPixsCz9oceQCpPeJ3wiNw@mail.gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/12 00:53, Muthu Kumar wrote:

> Hmm... Shouldn't this be:
> 
> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> Tested-by: Bart Van Assche <bvanassche@acm.org>


I'll modify that part of the patch if you prefer to be mentioned as the
author. I hadn't done that because you hadn't posted the patch in its
entirety yet.

 
> This part already went in, its here only for testing - So in the final
> patch, before applying this should be removed.


When did it go in ? As far as I can see that patch is not yet present in
Linus' tree nor in James' tree.

Bart.
