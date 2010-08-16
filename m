Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab0HPUti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:49:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:35220 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab0HPUsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:48:47 -0400
Subject: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTincMAv0OLYHSqHNwrhfKBC-yQHhgWdqKYHoJNOf@mail.gmail.com>
References: <4C5BE640.2050801@fusionio.com>
	 <AANLkTindzwVR93MN=6HpevQZh5EqfvnmbzEj9OeG-PLJ@mail.gmail.com>
	 <AANLkTi=WyWdERdyM+X5VOTX02_O_5GqV9hBQ145RmMWg@mail.gmail.com>
	 <4C5D0C79.5010103@fusionio.com>
	 <AANLkTincMAv0OLYHSqHNwrhfKBC-yQHhgWdqKYHoJNOf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 21:48:30 +0100
Message-ID: <1281991710.30341.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-07 at 14:15 -0700, Linus Torvalds wrote:
> 
>  It might well make sense to base linux-next itself on the
> latest tagged release rather than on some random daily thing (and if
> the things that get merged _into_ linux-next then are based on a
> random daily thing and bring linux-next forward, then that's a problem
> with the trees getting merged - they shouldn't be doing that either).

Hm? I do that whenever you pull from me -- I'll pull the merge commit
into my own tree. So the mtd-2.6.git tree you pulled last night, for
example, was based on some "random daily thing" half-way between 2.6.35
and 2.6.26-rc1, which happened to be entitled 'Merge git://...mtd-2.6'.

I try to avoid having to *merge* such a thing, but it certainly does end
up in linux-next as the *base* for maintainers' tree. It's difficult to
see how that could be avoided.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

