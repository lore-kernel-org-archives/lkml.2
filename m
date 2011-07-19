Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1GSPlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 11:41:40 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46177
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556Ab1GSPlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 11:41:39 -0400
Date: Tue, 19 Jul 2011 11:41:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bryan Donlan <bdonlan@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC][PATCH] Anonymous shared memory (ashmem) subsystem
Message-ID: <20110719154130.GA26245@infradead.org>
References: <1311015274-28650-1-git-send-email-john.stultz@linaro.org>
 <20110719021947.GA16986@infradead.org>
 <CAF_S4t_oOwsuPJdMXv+wPVhzecUag=TOWj1-KtFJqYUZOCBbog@mail.gmail.com>
 <20110719033602.GA4867@infradead.org>
 <1311089863.29817.172.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311089863.29817.172.camel@nimitz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 08:37:43AM -0700, Dave Hansen wrote:
> This implementation has some real show-stopper things in it, like its
> own LRU.  But, the concept seems interesting at least.

So if you care about it implement it sanely and not like a monkey on
crack would do it.  Having a madvice flag to allow reclaiming tmpfs
pages, and using the normal VM infrastructure sounds like a perfectly
fine feature.

