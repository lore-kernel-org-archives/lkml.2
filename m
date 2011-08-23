Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1HWMbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 08:31:35 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54649 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1HWMb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 08:31:29 -0400
Subject: Re: [PATCH 2/2 v2] block: separate priority boosting from REQ_META
From: Namhyung Kim <namhyung@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110823100940.GA4903@infradead.org>
References: <4E4E6238.3080808@fusionio.com>
	 <20110820174137.GA27243@infradead.org> <4E5146C1.508@fusionio.com>
	 <20110821181935.GA28979@infradead.org> <4E515057.7040802@fusionio.com>
	 <20110822165221.GB7257@infradead.org> <87r54cg9vn.fsf@gmail.com>
	 <20110823100940.GA4903@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 21:31:22 +0900
Message-ID: <1314102682.1595.1.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-08-23 (화), 06:09 -0400, Christoph Hellwig:
> Add a new REQ_PRIO to let requests preempt others in the cfq I/O schedule,
> and lave REQ_META purely for marking requests as metadata in blktrace.
> 
> All existing callers of REQ_META except for XFS are updated to also
> set REQ_PRIO for now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Namhyung Kim <namhyung@gmail.com>

Thanks.


-- 
Regards,
Namhyung Kim


