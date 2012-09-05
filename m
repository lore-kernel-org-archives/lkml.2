Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab2IEItV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:49:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40341 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2IEItU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:49:20 -0400
Date: Wed, 5 Sep 2012 01:49:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
Message-ID: <20120905084915.GF3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <8439412.RChiDciQdh@fat-tyre>
 <20120904224620.GB9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <3029802.oqG0dEY71l@fat-tyre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3029802.oqG0dEY71l@fat-tyre>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 10:44:55AM +0200, Philipp Reisner wrote:
> > Currently, FLUSH/FUA doesn't enforce any ordering requirement.  File
> > systems are responsible for draining all writes which have to happen
> > before and not issue further writes which should come after.
> 
> Ok. That is a clear statement. So we will do it that way.
> 
> The "Currently" in you statement, suggests that there might be something
> more mighty in the future. Is that true?

Heh, I was more thinking about the past.  We used to have barrier
support with much stricter ordering.  I don't think we're gonna change
the ordering requirement in any foreseeable future.

Thanks.

-- 
tejun
