Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab0JPHzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:55:20 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60460 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753342Ab0JPHzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:55:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBA
Date: Sat, 16 Oct 2010 18:55:15 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/17] fs: Clean up inode reference counting
Message-ID: <20101016075515.GI19147@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-18-git-send-email-david@fromorbit.com>
 <20100930021520.GA21198@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930021520.GA21198@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:15:20PM -0400, Christoph Hellwig wrote:
> Besides moving this much earlier in the series as mentioned before
> the most important thing is giving the helpers a different name as
> the iget name is already used for a different purpose, even if
> got rid of the original iget and only have iget_locked.

It's a bit of a mess. We also have __iget. I don't care much about
the name though so I'll see what you've chosen in future posts.

I'll see how it looks to move earlier in the series, shouldn't
be a big problem.

