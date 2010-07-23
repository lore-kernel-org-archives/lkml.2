Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446Ab0GWPKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:10:17 -0400
Received: from smtp.nokia.com ([192.100.122.230]:30244 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760133Ab0GWPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:10:12 -0400
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nick Piggin <npiggin@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100722080511.GA9377@amd>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
	 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
	 <20100722031922.GA3446@amd> <1279781304.3044.12.camel@localhost>
	 <20100722080511.GA9377@amd>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 18:03:02 +0300
Message-ID: <1279897382.9203.95.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Jul 2010 15:10:00.0517 (UTC) FILETIME=[1EBAF750:01CB2A79]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 18:05 +1000, Nick Piggin wrote:
> This is producing 2 unrequired context switches, so I really would
> like to see it done properly. Setting up a timer is really pretty
> simple (or if you would care to implement a delayed process wakeup
> API, I think that would be useful -- I'm surprised there isn't one
> already).

It reduces flusher thread wake-up count a lot, BTW. I've just sent v4 of
the patch set which implements this, see patch 12.

Nick, could you please take a look at patch 10 in that v4 series. I've
added memory barriers, they are always tricky, and last time I remember
you helped me to use barriers properly.

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

