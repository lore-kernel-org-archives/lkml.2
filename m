Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0IVNZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 09:25:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41791 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab0IVNZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 09:25:10 -0400
Date: Wed, 22 Sep 2010 15:25:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: John Kacur <jkacur@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf build fixes for opensuse 10.0
Message-ID: <20100922132509.GD5766@basil.fritz.box>
References: <20100922090336.GA5338@basil.fritz.box>
 <AANLkTimqa1++9kNcODikTVMOExhypX6+kY_m7dCKb=64@mail.gmail.com>
 <fdf800a16e7e44f19a684d4a4bf67288.squirrel@www.firstfloor.org>
 <AANLkTimqTva4gYncxzeMokT19rYqZ4kj5p=jONYXmP7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimqTva4gYncxzeMokT19rYqZ4kj5p=jONYXmP7Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 03:10:04PM +0200, John Kacur wrote:
> On Wed, Sep 22, 2010 at 1:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >> On Wed, Sep 22, 2010 at 11:03 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >>> Fix the perf Makefile to compile on opensuse 10.0
> >>>
> >>> -Werror in shipping code is usually a bad idea. Remove that.
> >>
> >> Why not remove it then when you ship the code, but leave it in the kernel
> >> where it is useful?
> >
> > What do you mean with "you ship"?
> 
> The subject of your email is "perf build fixes for opensuse 10.0"
> So, I inferred from there.

You inferred wrong.  That was just using it on opensuse 10.0

(opensuse 10.0 has already shipped a very long time ago, it's really
old by now)

> 
> > I downloaded a kernel from kernel.org, it shipped to me and didn't
> > build.
> 
> Any reason you can't fix the build errors instead?

That's what I did -- and then sent the patch.

> Btw, I just tried building the lastest perf in tip/master
> and I had no problems.

Because you're not using opensuse 10.0

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
