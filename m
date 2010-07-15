Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934498Ab0GOT1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:27:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934384Ab0GOT06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:26:58 -0400
Date: Thu, 15 Jul 2010 12:26:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-mmc Mailing List <linux-mmc@vger.kernel.org>,
        linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Add secure discard
Message-Id: <20100715122601.a087f71c.akpm@linux-foundation.org>
In-Reply-To: <4C3D967F.9070305@nokia.com>
References: <20100707111716.24979.68940.sendpatchset@ahunter-work.research.nokia.com>
	<20100707111749.24979.69982.sendpatchset@ahunter-work.research.nokia.com>
	<4C3C0A71.2080407@nokia.com>
	<20100714031632.GA346@lst.de>
	<4C3D967F.9070305@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 13:50:39 +0300
Adrian Hunter <adrian.hunter@nokia.com> wrote:

> >From 9ba7750fb96d9994e8715b14d8091c37b832b3e6 Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Wed, 23 Jun 2010 15:41:38 +0300
> Subject: [PATCH] block: Add secure discard
> 
> Secure discard is the same as discard except that all copies
> of the discarded sectors (perhaps created by garbage collection)
> must also be erased.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
> ---
> 
> 
> 
> Here is "[PATCH V4 4/5] block: Add secure discard" applied to
> git://git.kernel.dk/linux-2.6-block.git for-next.
> 
> If Jens takes this patch (originally 4th of 5),  Andrew takes patches 1 to 3,
> and patch 5 waits for this one to propagate, then there will be no dependency
> problem.

hm, complicated.

I merged all five into -mm.  If Jens sends along some acks then I send
all five along to Linus, nice and simple.

