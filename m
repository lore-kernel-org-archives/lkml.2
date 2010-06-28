Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0F1DbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 23:31:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58811 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab0F1DbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 23:31:07 -0400
Date: Mon, 28 Jun 2010 13:30:54 +1000
From: Nick Piggin <npiggin@suse.de>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: Slow vmalloc in 2.6.35-rc3
Message-ID: <20100628033054.GL29809@laptop>
References: <4C232324.7070305@redhat.com>
 <20100624151427.GH10441@laptop>
 <4C271736.5010102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C271736.5010102@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 12:17:42PM +0300, Avi Kivity wrote:
> On 06/24/2010 06:14 PM, Nick Piggin wrote:
> >On Thu, Jun 24, 2010 at 12:19:32PM +0300, Avi Kivity wrote:
> >>I see really slow vmalloc performance on 2.6.35-rc3:
> >Can you try this patch?
> >http://userweb.kernel.org/~akpm/mmotm/broken-out/mm-vmap-area-cache.patch
> 
> The patch completely eliminates the problem.

Thanks for testing. Andrew the patch changelog can be updated.  Avi and
Steven didn't give me numbers but it solves both their performance
regressions, so I would say it is ready for merging.

Thanks,
Nick


