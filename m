Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab0FHFoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 01:44:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:38454 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab0FHFox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 01:44:53 -0400
Date: Tue, 8 Jun 2010 15:44:46 +1000
From: Nick Piggin <npiggin@suse.de>
To: Dave Chinner <david@fromorbit.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/6] writeback: tracing and fixes V4
Message-ID: <20100608054446.GT26335@laptop>
References: <1275957487-23633-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275957487-23633-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 10:38:01AM +1000, Dave Chinner wrote:
> Hi Linus,
> 
> Can you please consider this patch series for 2.6.35? If you don't
> want the tracing at this stage of the release process, I can redo
> the series with just the bug fixes. However, given the regularity
> with which we break the writeback code in subtle ways, the tracing
> is probably just as important as the bug fixes.

Oh, I don't have a problem with your EOF fix being merged now, as Jan's
patch isn't suitable for 2.6.35.

