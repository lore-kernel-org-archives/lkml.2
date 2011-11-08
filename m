Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1KHXxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:53:15 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57820 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756520Ab1KHXxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:53:10 -0500
X-Sasl-enc: yrq9kY4gk5xxpBvVQNkX9v3rhj1P4/gAMnd1goYCs0LH 1320796389
Date: Tue, 8 Nov 2011 15:52:56 -0800
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "George G. Davis" <gdavis@mvista.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org,
        jason.wessel@windriver.com, Andi Kleen <andi@firstfloor.org>,
        lwn@lwn.net
Subject: Re: Announcement: Plans for v2.6.34-longterm
Message-ID: <20111108235256.GB9866@kroah.com>
References: <20101203210719.GB21223@windriver.com>
 <ADA45A9A-E9A4-4B4C-80FF-711340F931BB@mvista.com>
 <4EB9B731.9040804@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB9B731.9040804@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 06:11:45PM -0500, Paul Gortmaker wrote:
> On 11-11-08 05:14 PM, George G. Davis wrote:
> > Greetings,
> > 
> 
> [...]
> 
> > 
> > Are there any plans to continue maintenance of v2.6.34-longterm now that
> > kernel.org is back online?
> 
> Yes,  in fact I have a queue ready for review shortly.  However I didn't
> want to overtax the kernel.org maintainers with nagging questions about
> longterm/stable directory layout & restoration -- as I'm sure they had more
> than their hands full with getting people back on the server and getting
> stuff functional for the merge window which just closed yesterday.

Ah, I'll handle this :)

So, in talking with Andi, we decided that I would just keep the "main"
linux-stable.git tree on kernel.org.  When you do a new release, I'll
merge that into the linux-stable.git tree and do the "official" tarball
release with the proper stable kernel signing key.

This should make your life a whole lot easier, just clone the existing
linux-stable.git tree, add your releases to the proper branch, and do a
pull request to me when you have it all ready to go.

It also makes managing things on the kernel.org side easier with
permissions and the like, as sharing a git tree can get messy as we've
seen in the past.

Sound reasonable?

Also, I would like to populate the linux-stable.git tree with the
missing .34-longterm releases that you have already done, care to
provide a git tree that I can pull from for those now?

Oh, you will need a kernel.org account for this, but I'm assuming that
you already have that set up, right?  If not, please do that first and
if you have any problems with it, let me know.

thanks,

greg k-h
