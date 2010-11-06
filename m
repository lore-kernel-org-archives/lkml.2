Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab0KFXkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 19:40:42 -0400
Received: from THUNK.ORG ([69.25.196.29]:48693 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab0KFXkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 19:40:41 -0400
Date: Sat, 6 Nov 2010 19:40:29 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Greg KH <greg@kroah.com>, Elvis Dowson <elvis.dowson@mac.com>,
        Janakiram Sistla <janakiram.sistla@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101106234029.GC2935@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Anca Emanuel <anca.emanuel@gmail.com>, Greg KH <greg@kroah.com>,
	Elvis Dowson <elvis.dowson@mac.com>,
	Janakiram Sistla <janakiram.sistla@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
 <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
 <20101106181202.GA6927@kroah.com>
 <20101106192259.GB2935@thunk.org>
 <AANLkTikQoAbsKX=N-ST3KVqSxBnA6OhNvd7FehLDnn=V@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikQoAbsKX=N-ST3KVqSxBnA6OhNvd7FehLDnn=V@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 09:40:34PM +0200, Anca Emanuel wrote:
> I think you need to see this: https://review.source.android.com/#change,18761
> And this: http://galaxytab.samsungmobile.com/

What about them?  Yes, the Android developers are pushing changes to
mainstream where it makes sense; they were doing this before the
wakelocks contrversy, and they're continuing to do it now.  But in the
case of wakelocks, it may be that it's going to have to be a case of
"agree to disagree".

All distributions, including Red Hat and SLES has in the shipped
product with patches that have never hit mainstream, and in some
cases, will never get merged with mainstream.  A good example in the
past was the 4G/4G patch.  Another one, which is still on-going, is
the Systemtap/utrace patches.  Yet no one is killing megawatts worth
of electrons about how Red Hat and SLES are forking the kernel.  They
push patches upstream where they can, and where they can't --- they do
what they need to do to satisify and delight their customers.  

(Heck, Sony is still using a 2.2 kernel for some of their products
with a huge bunch of patches and no one is toasting them for forking
the kernel....)

Move along, there's nothing to see.  Other that money for
journalists/bloggers who are gunning for advertising clicks by
whipping up controversy where IMHO, none deserves to exist.

					- Ted
