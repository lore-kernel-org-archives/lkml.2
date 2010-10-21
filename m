Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab0JUNUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:20:39 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:35433 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757923Ab0JUNUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:20:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhYEAGfav0x5LdoFgWdsb2JhbAChWBYBARYiIsAvhUoE
Date: Fri, 22 Oct 2010 00:20:34 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V7 (was V6)
Message-ID: <20101021132034.GB13620@amd>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <20101021050422.GP32255@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021050422.GP32255@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems we are at an impasse.

It doesn't help that you are ignoring the most important concerns
I've been raising with these patches. The locking model and the
patch split up. I'd really like not to get deadlocked on this (haha),
so please let's try to debate points. I've tried to reply to each
point others have questioned me about, whether I agree or not I've
given reasons.

So, you know my objections to this approach already... I've got an
update on my patchset coming, so I'd like to get some discussion
going. I've cut out some of the stuff from mine so we don't get
bogged down in boring things like per-zone locking or changing of
the hash table data structure.

Thanks,
Nick

