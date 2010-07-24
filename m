Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0GXGIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 02:08:42 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34308 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab0GXGIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 02:08:30 -0400
Subject: Re: [PATCHv4 14/14] writeback: add new tracepoints
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100723162919.GD29633@infradead.org>
References: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
	 <1279897554-1526-15-git-send-email-dedekind1@gmail.com>
	 <20100723162919.GD29633@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Jul 2010 09:01:10 +0300
Message-ID: <1279951270.4655.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jul 2010 06:08:15.0437 (UTC) FILETIME=[9A9B1FD0:01CB2AF6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 12:29 -0400, Christoph Hellwig wrote:
> On Fri, Jul 23, 2010 at 06:05:54PM +0300, Artem Bityutskiy wrote:
> > From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> > 
> > Add 2 new trace points to the periodic write-back wake up case, just like we do
> > in the 'bdi_queue_work()' function. Namely, introduce:
> > 
> > 1. trace_writeback_wakeup(bdi)
> > 2. trace_writeback_wakeup_nothread(bdi)
> > 
> > The first event is triggered every time we wake up a bdi thread to start
> > periodic background write-out. The second event is triggered only when the bdi
> > thread does not exist and should be created by the forker thread.
> > 
> > This patch was suggested by Dave Chinner <david@fromorbit.com>
> 
> As mentioned before doing the wakeup just for the case where we
> really wake up the flusher thead is much better.  It's not 100%
> clear for bdi_queue_work as we queue the work in either case, but
> I'd prefer to fix that one up as well (not in your series anyway)

OK, I'll do it your way. Many thanks for review!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

