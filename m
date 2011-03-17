Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1CQBwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 21:52:00 -0400
Received: from kroah.org ([198.145.64.141]:38448 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab1CQBvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 21:51:42 -0400
Date: Wed, 16 Mar 2011 18:52:39 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [GIT PATCH] STAGING patches for .39
Message-ID: <20110317015239.GB31754@kroah.com>
References: <20110316210300.GA3311@kroah.com>
 <AANLkTim13aZ0Mr5RrOeQizHGY3jhf97x8v9mznY8RqgE@mail.gmail.com>
 <20110317002818.GA19812@kroah.com>
 <AANLkTikEEDDFxZQtvV46JJRU1NAtiXh_N4onJ1jwKHaF@mail.gmail.com>
 <AANLkTinznDAXuxv8AU=tZpTq81f_S8vTyAqRMm=nfAKS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinznDAXuxv8AU=tZpTq81f_S8vTyAqRMm=nfAKS@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 05:34:08PM -0700, Linus Torvalds wrote:
> On Wed, Mar 16, 2011 at 5:32 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > The one with inifinite errors was vt6655.
> 
> vt6656 had same/similar issues. In fact, maybe it's simply because I
> built both of them in, and get infinite "multiple definitions" because
> they are the same driver with small differences?

Ah, probably, if they are both built into the kernel that might happen
due to the global symbols in them.  Actually that's odd, Randy's usual
'randconfig' tester usually catches these, I'll make the Kconfig files
force them to be modules to keep this from happening in the future.

thanks,

greg k-h
