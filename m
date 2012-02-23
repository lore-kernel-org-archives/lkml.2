Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2BWVw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:52:57 -0500
Received: from 1wt.eu ([62.212.114.60]:62572 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab2BWVw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:52:56 -0500
Date: Thu, 23 Feb 2012 22:52:42 +0100
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
Message-ID: <20120223215242.GA1306@1wt.eu>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org> <20120222211928.GA4448@kroah.com> <CA+55aFz0pOO6j9s3Gs2UJLM4zm8SuPgi5iUiVAaPCp9Xh2Pvjw@mail.gmail.com> <20120222213253.GA25150@kroah.com> <20120223200905.GA5475@kroah.com> <4F46A1C4.90506@zytor.com> <20120223204832.GA30322@kroah.com> <4F46A6EC.8050804@zytor.com> <20120223211016.GA16275@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223211016.GA16275@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 23, 2012 at 01:10:16PM -0800, Greg Kroah-Hartman wrote:
> On Thu, Feb 23, 2012 at 12:51:56PM -0800, H. Peter Anvin wrote:
> > On 02/23/2012 12:48 PM, Greg Kroah-Hartman wrote:
> > > On Thu, Feb 23, 2012 at 12:29:56PM -0800, H. Peter Anvin wrote:
> > >> On 02/23/2012 12:09 PM, Greg Kroah-Hartman wrote:
> > >>>
> > >>> I've applied this now to the 3.0 and 3.2-stable trees.  It looks like it
> > >>> would work on the 2.6.32-stable tree, but it needs some tweaks, and as I
> > >>> can't really test this, and the .32-stable tree is probably not going to
> > >>> have problems in this area, I'll let someone else generate those patches
> > >>> and test them if they feel it is needed there.
> > >>>
> > >>
> > >> It doesn't seem to appear in the stable git tree... anywhere I can get
> > >> your tree so I can test these out?
> > > 
> > > They are in the stable-queue git tree at:
> > > 	/pub/scm/linux/kernel/git/stable/stable-queue.git
> > > on git.kernel.org
> > > 
> > > Testing them out would be great, if you want, I can knock up a git tree
> > > with just these patches in it on 3.2.7 or anything else you need to test
> > > with, if that makes it easier for you.
> > > 
> > 
> > That would be awesome.
> 
> Ok, the patches are at:
> 	git.kernel.org/pub/scm/linux/kernel/git/gregkh/stable-test.git linux-3.2.y-i387-test
> 
> They are on top of the 3.2.7 kernel release.
> 
> If that doesn't work for you, please let me know.

I would test this too, but apart from ensuring my kernel still boots,
how do I ensure the patches do really fix what the ought to fix ? I
must admit I didn't catch the initial issue they were supposed to fix
unfortunately :-/

Thanks,
Willy

