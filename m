Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0JHIFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:05:08 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:45749 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752490Ab0JHIFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:05:04 -0400
Date: Fri, 8 Oct 2010 19:05:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101008080500.GX4681@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-16-git-send-email-david@fromorbit.com>
 <20101008075320.GA30902@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008075320.GA30902@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 03:53:20AM -0400, Christoph Hellwig wrote:
> > +static unsigned int last_ino_get(void)
> 
> Shouldn't this be get_next_ino?

Sure, that sounds better....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
