Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab1GSV7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 17:59:08 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36511 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab1GSV7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 17:59:06 -0400
Subject: Re: [RFC][PATCH] Anonymous shared memory (ashmem) subsystem
From: John Stultz <john.stultz@linaro.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Bryan Donlan <bdonlan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20110719154130.GA26245@infradead.org>
References: <1311015274-28650-1-git-send-email-john.stultz@linaro.org>
	 <20110719021947.GA16986@infradead.org>
	 <CAF_S4t_oOwsuPJdMXv+wPVhzecUag=TOWj1-KtFJqYUZOCBbog@mail.gmail.com>
	 <20110719033602.GA4867@infradead.org> <1311089863.29817.172.camel@nimitz>
	 <20110719154130.GA26245@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 14:58:56 -0700
Message-ID: <1311112736.2945.106.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 11:41 -0400, Christoph Hellwig wrote:
> On Tue, Jul 19, 2011 at 08:37:43AM -0700, Dave Hansen wrote:
> > This implementation has some real show-stopper things in it, like its
> > own LRU.  But, the concept seems interesting at least.
[snip]
> Having a madvice flag to allow reclaiming tmpfs
> pages, and using the normal VM infrastructure sounds like a perfectly
> fine feature.

Ok. Thanks all for the review and comments. I'll see if something like
what was suggested can be worked out.

thanks again,
-john



