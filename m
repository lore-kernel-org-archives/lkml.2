Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab1KNUBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 15:01:07 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60096
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754299Ab1KNUBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 15:01:05 -0500
Date: Mon, 14 Nov 2011 15:01:00 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        bpm@sgi.com, xfs@oss.sgi.com
Subject: Re: [PATCH] workqueue: make alloc_workqueue() take printf fmt and
 args for name
Message-ID: <20111114200100.GA18155@infradead.org>
References: <20111114194248.GD30922@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111114194248.GD30922@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 11:42:48AM -0800, Tejun Heo wrote:
> Christoph, you probably were seeing the rescuer_task->comm in ps
> output.  wq->name currently is currently only used for error
> reporting.
> 
> I don't really mind this patch going through a different tree as I
> don't have any other wq changes scheduled at this point, so please
> feel free to route this through xfs or -mm.

Ben pointed the bug out in a patch that I'd like to get into 3.2
and -stable.  I'll probably repost it with a local workaround for now,
and will switch to the nicer interface later.

