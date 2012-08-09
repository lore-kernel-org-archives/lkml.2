Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab2HINVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:21:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:59511 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196Ab2HINVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:21:49 -0400
Message-ID: <5023B94C.7000302@kernel.dk>
Date: Thu, 09 Aug 2012 15:21:16 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        peterz@infradead.org, davem@davemloft.net, tomi.valkeinen@ti.com,
        Jiri Kosina <jkosina@suse.cz>, Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH 7/7] workqueue: deprecate __cancel_delayed_work()
References: <1344461882-10149-1-git-send-email-tj@kernel.org> <1344461882-10149-8-git-send-email-tj@kernel.org>
In-Reply-To: <1344461882-10149-8-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 11:38 PM, Tejun Heo wrote:
> Now that cancel_delayed_work() can be safely called from IRQ handlers,
> there's no reason to use __cancel_delayed_work().  Use
> cancel_delayed_work() instead of __cancel_delayed_work() and mark the
> latter deprecated.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Roland Dreier <roland@kernel.org>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>

You can add my acked by to this one.

-- 
Jens Axboe

