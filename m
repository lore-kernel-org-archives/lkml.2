Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0KGAAg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 20:00:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:49478 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab0KGAAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 20:00:35 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Nov 2010 20:00:35 EDT
Date: Sat, 6 Nov 2010 16:52:26 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Ted Ts'o" <tytso@mit.edu>
cc: Anca Emanuel <anca.emanuel@gmail.com>, Greg KH <greg@kroah.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Janakiram Sistla <janakiram.sistla@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
In-Reply-To: <20101106234029.GC2935@thunk.org>
Message-ID: <alpine.DEB.2.00.1011061646170.29342@asgard.lang.hm>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com> <20101106181202.GA6927@kroah.com> <20101106192259.GB2935@thunk.org> <AANLkTikQoAbsKX=N-ST3KVqSxBnA6OhNvd7FehLDnn=V@mail.gmail.com>
 <20101106234029.GC2935@thunk.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Nov 2010, Ted Ts'o wrote:

> On Sat, Nov 06, 2010 at 09:40:34PM +0200, Anca Emanuel wrote:
>> I think you need to see this: https://review.source.android.com/#change,18761
>> And this: http://galaxytab.samsungmobile.com/
>
> What about them?  Yes, the Android developers are pushing changes to
> mainstream where it makes sense; they were doing this before the
> wakelocks contrversy, and they're continuing to do it now.  But in the
> case of wakelocks, it may be that it's going to have to be a case of
> "agree to disagree".
>
> All distributions, including Red Hat and SLES has in the shipped
> product with patches that have never hit mainstream, and in some
> cases, will never get merged with mainstream.  A good example in the
> past was the 4G/4G patch.  Another one, which is still on-going, is
> the Systemtap/utrace patches.  Yet no one is killing megawatts worth
> of electrons about how Red Hat and SLES are forking the kernel.  They
> push patches upstream where they can, and where they can't --- they do
> what they need to do to satisify and delight their customers.
>
> (Heck, Sony is still using a 2.2 kernel for some of their products
> with a huge bunch of patches and no one is toasting them for forking
> the kernel....)

the difference is that these other patches that you are talking about do 
not result in incompatible userspace (or at least, they don't except for 
very specialied apps).

also, none of these other patches resulted in device drivers developed for 
a distro being incompatible with mainline.

I think that the concerns from technical folks (as opposed to 
journalists/bloggers) would go down drastically if there was some 
acceptable way for the incompatible bits (like wakelocks) could be 
stubbed out so that the rest of the things could be moved easily.

David Lang

> Move along, there's nothing to see.  Other that money for
> journalists/bloggers who are gunning for advertising clicks by
> whipping up controversy where IMHO, none deserves to exist.
>
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
