Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab1GOP1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:27:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37230
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382Ab1GOP1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:27:45 -0400
Date: Fri, 15 Jul 2011 11:27:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/14] Swap-over-NBD without deadlocking v5
Message-ID: <20110715152738.GA2276@infradead.org>
References: <1308575540-25219-1-git-send-email-mgorman@suse.de>
 <20110706165146.be7ab61b.akpm@linux-foundation.org>
 <20110707094737.GG15285@suse.de>
 <20110707125831.GA15412@infradead.org>
 <20110715141021.GZ7529@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715141021.GZ7529@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 03:10:21PM +0100, Mel Gorman wrote:
> Any objection to the swap-over-NBD stuff going ahead to get part of the
> complexity out of the way?

Sure, that's what I was advocating for.  The filesystem interfaces in
the current swap over nbd patches on the other hand are complete crap
and need to be redone, but we've already discussed that a lot of times.

