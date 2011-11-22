Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab1KVW7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:59:12 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:49617 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab1KVW7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:59:11 -0500
Message-ID: <1322002702.6445.95.camel@work-vm>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and
 _NONVOLATILE flags
From: John Stultz <john.stultz@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Tue, 22 Nov 2011 14:58:22 -0800
In-Reply-To: <20111122133909.ebe72517.akpm@linux-foundation.org>
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org>
	 <20111122125209.7f70f3a7.akpm@linux-foundation.org>
	 <1321997538.6445.90.camel@work-vm>
	 <20111122133909.ebe72517.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11112222-7282-0000-0000-0000042BAC53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 13:39 -0800, Andrew Morton wrote:
> On Tue, 22 Nov 2011 13:32:18 -0800
> John Stultz <john.stultz@linaro.org> wrote:
> 
> > Very cool!  Yea. Dave brought up that the list was fairly inefficient,
> > but I figured I'd get more feedback on the mechanism before spending too
> > much time optimizing the structure. I'll look at your mumbletree code
> > and see how it can be adapted. Other then apparently being a nod to the
> > "original neo-grunge/indie-rock band from Rochester", is there a story
> > to the name? :)
> 
> I was first!

Sorry! Didn't realize it was the other way around. Hopefully reading the
code will inform my listening. :)

> I was sure there was some correct term for such a tree in the
> literature, but I didn't know what it was and the compiler didn't like
> "*_tree".
> 
> > Again, I appreciate the feedback! Thanks so much!
> 
> I note you sneakily deleted the bit about posix/bsd file locking.

Oh, no sneakiness intended. I agree about the parallels, and didn't
really have anything to add. Hopefully the needs here are a little bit
simpler, since we can coalesce regions. Maybe that will let us avoid the
worst of it?

thanks
-john


