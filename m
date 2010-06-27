Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab0F0Qoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 12:44:46 -0400
Received: from borg.medozas.de ([188.40.89.202]:51264 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552Ab0F0Qoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 12:44:44 -0400
Date: Sun, 27 Jun 2010 18:44:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jan Kara <jack@suse.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
In-Reply-To: <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
Message-ID: <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain> <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr> <20100215144938.GD3434@quack.suse.cz> <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jan Kara,


On Monday 2010-02-15 16:41, Jan Engelhardt wrote:
>On Monday 2010-02-15 15:49, Jan Kara wrote:
>>On Sat 13-02-10 13:58:19, Jan Engelhardt wrote:
>>> >> 
>>> >> This fixes it by using the passed in page writeback count, instead of
>>> >> doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
>>> >> (Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
>>> >> finish properly even when new pages are being dirted.
>>> >
>>> >This seems broken.
>>> 
>>> It seems so. Jens, Jan Kara, your patch does not entirely fix this.
>>> While there is no sync/fsync to be seen in these traces, I can
>>> tell there's a livelock, without Dirty decreasing at all.

What ultimately became of the discussion and/or the patch? 

Your original ad-hoc patch certainly still does its job; had no need to 
reboot in 86 days and still counting.
