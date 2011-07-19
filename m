Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1GSCT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 22:19:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46391
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029Ab1GSCTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 22:19:55 -0400
Date: Mon, 18 Jul 2011 22:19:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC][PATCH] Anonymous shared memory (ashmem) subsystem
Message-ID: <20110719021947.GA16986@infradead.org>
References: <1311015274-28650-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311015274-28650-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 11:54:34AM -0700, John Stultz wrote:
> From: Robert Love <rlove@google.com>
> 
> Recently, Robert Love updated his ashmem patch and posted it here:
> 	http://www.kernel.org/pub/linux/kernel/people/rml/ashmem/
> 
> This reminded me that in all the conversations around the Android patches,
> I've not seen any discussion on lkml about the ashmem functionality. 
> Coming from Robert, its very clean and self-contained and seems pretty
> interesting. So I wanted to send it out for review and comments.

And utterly stupid, just use tmpfs and /dev/zero for the base functionality.

And the pinning crap really needs a much better rationale.

