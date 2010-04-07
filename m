Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab0DGLRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 07:17:10 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55173 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0DGLRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 07:17:06 -0400
Date: Wed, 7 Apr 2010 13:17:02 +0200
From: Andreas Mohr <andi@lisas.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andreas Mohr <andi@lisas.de>, Jens Axboe <axboe@kernel.dk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 32GB SSD on USB1.1 P3/700 == ___HELL___ (2.6.34-rc3)
Message-ID: <20100407111702.GA3676@rhlx01.hs-esslingen.de>
References: <20100404221349.GA18036@rhlx01.hs-esslingen.de> <20100405105319.GA16528@rhlx01.hs-esslingen.de> <20100407070050.GA10527@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100407070050.GA10527@localhost>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 07, 2010 at 03:00:50PM +0800, Wu Fengguang wrote:
> Many applications (this one and below) are stuck in
> wait_on_page_writeback(). I guess this is why "heavy write to
> irrelevant partition stalls the whole system".  They are stuck on page
> allocation. Your 512MB system memory is a bit tight, so reclaim
> pressure is a bit high, which triggers the wait-on-writeback logic.

"Your 512MB system memory is a bit tight".
Heh, try to survive making such a statement 15 years ago ;)
(but you likely meant this in the context of inducing a whopping 300MB write)

Thank you for your reply, I'll test the patch ASAP (with large writes
and Firefox sync mixed in), maybe this will improve things already.

Andreas Mohr
