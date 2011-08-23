Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1HWNKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:10:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40024 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755342Ab1HWNJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:09:49 -0400
Date: Tue, 23 Aug 2011 14:09:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 03/16] ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead
 of PGDIR_*
Message-ID: <20110823130930.GA17397@e102109-lin.cambridge.arm.com>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
 <1312988619-16804-4-git-send-email-catalin.marinas@arm.com>
 <20110823111533.GH19622@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823111533.GH19622@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 12:15:33PM +0100, Russell King - ARM Linux wrote:
> On Wed, Aug 10, 2011 at 04:03:26PM +0100, Catalin Marinas wrote:
> > @@ -183,7 +183,7 @@ static int __init consistent_init(void)
> >  		}
> >  
> >  		consistent_pte[i++] = pte;
> > -		base += (1 << PGDIR_SHIFT);
> > +		base += (1 << PMD_SHIFT);
> 
> Please replace with PMD_SIZE.
> 
> Once combined with the "fixup! ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*"
> patch (and once whatever "fixup!" is done) this can be submitted to the
> patch system.

I send this one (with the folded fix-ups) and the other type casting to
your patch system (the "fixup!" is generated with git commit --fixup and
git rebase -i --autosquash does the folding automatically).

-- 
Catalin
