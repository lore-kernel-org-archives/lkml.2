Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab0EaRqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:46:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40679 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab0EaRqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:46:17 -0400
Date: Mon, 31 May 2010 19:46:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, herbert@gondor.hengli.com.au,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com,
       ak@linux.intel.com
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs
Message-ID: <20100531174611.GF10766@basil.fritz.box>
References: <20100531160425.GA20344@basil.fritz.box> <1275323695.3291.122.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275323695.3291.122.camel@edumazet-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 06:34:55PM +0200, Eric Dumazet wrote:

Yes seems like I'm behind on per cpu innovations.

> Since commit e0fdb0e050eae331, we have a __percpu annotation so that
> sparse can be augmented. This would also make the comment unnecessary...

I think the comment is still necessary.

> 
> > +       __get_cpu_var(io_wq_cpu) = current;
> 
> 	this_cpu_write(io_wq_cpu, current)

And this one looks more ugly than before and does not seem
to generate better code, so I decided to skip it.

Thanks.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
