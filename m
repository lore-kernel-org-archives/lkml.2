Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab0JUNQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:16:12 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:2861 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754310Ab0JUNQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:16:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYEAGfav0x5LdoFgWdsb2JhbAChWBYBARYiIsAvhUoEj04
Date: Fri, 22 Oct 2010 00:16:02 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/21] fs: protect wake_up_inode with inode->i_lock
Message-ID: <20101021131602.GA13620@amd>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-18-git-send-email-david@fromorbit.com>
 <20101021021722.GB5241@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021021722.GB5241@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 10:17:22PM -0400, Christoph Hellwig wrote:
> Looks good, and thanks for documenting unlock_new_inode.

You wanted an example of how the irregular locking requires
handling of new concurrency situations? This is another good
one.

