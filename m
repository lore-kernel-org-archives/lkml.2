Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab2JJGOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 02:14:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50646 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752386Ab2JJGOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 02:14:16 -0400
X-Sasl-enc: G/p1oOU3jTexaBFA1dBfVW6AlfcfhGoNDMH6qdlMzbQE 1349849655
Date: Wed, 10 Oct 2012 09:47:50 +0900
From: Greg KH <greg@kroah.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Stable <stable@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Memory policy corruption fixes -stable
Message-ID: <20121010004750.GA22823@kroah.com>
References: <1349801921-16598-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349801921-16598-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 05:58:36PM +0100, Mel Gorman wrote:
> This is a backport of the series "Memory policy corruption fixes V2". This
> should apply to 3.6-stable, 3.5-stable, 3.4-stable and 3.0-stable without
> any difficulty.  It will not apply cleanly to 3.2 but just drop the "revert"
> patch and the rest of the series should apply.
> 
> I tested 3.6-stable and 3.0-stable with just the revert and trinity breaks
> as expected for the mempolicy tests. Applying the full series in both case
> allowed trinity to complete successfully. Andi Kleen reported previously
> that the series fixed a database performance regression[1].
> 
> [1] https://lkml.org/lkml/2012/8/22/585
> 
>  include/linux/mempolicy.h |    2 +-
>  mm/mempolicy.c            |  137 +++++++++++++++++++++++++++++----------------
>  2 files changed, 89 insertions(+), 50 deletions(-)

Looks good, thanks, now all queued up.

greg k-h
