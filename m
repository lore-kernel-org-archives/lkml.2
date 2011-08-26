Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1HZVop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:44:45 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37630 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755552Ab1HZVok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:44:40 -0400
X-Sasl-enc: 1YXCy+BbXuqu6Ux7yWDg6A4u7YeUUUFYrhccvAaLFCQx 1314395079
Date: Fri, 26 Aug 2011 14:43:50 -0700
From: Greg KH <greg@kroah.com>
To: Karel Zak <kzak@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Andi Kleen <andi@firstfloor.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        util-linux@vger.kernel.org
Subject: Re: [PATCH] setarch: Add --uname-2.6 option for personality flag
 UNAME26
Message-ID: <20110826214350.GB6325@kroah.com>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
 <1314079201.12047.68.camel@deadeye>
 <20110823101601.GA23745@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110823101601.GA23745@nb.net.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 12:16:01PM +0200, Karel Zak wrote:
> On Tue, Aug 23, 2011 at 07:00:01AM +0100, Ben Hutchings wrote:
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> > On Fri, 2011-08-19 at 16:15 -0700, Andi Kleen wrote:
> > [...]
> > > To use:
> > > 
> > > wget ftp://ftp.kernel.org/pub/linux/kernel/people/ak/uname26/uname26.c
> > > gcc -o uname26 uname26.c
> > > ./uname26 program
> > [...]
> > 
> > I would suggest adding this to setarch, as that handles all the other
> > personality flags.  The following patch to util-linux seems to do the
> > trick.
> 
>  I have one simple rule: "Linus' tree first", and I don't see UNAME26
>  in include/linux/personality.h ...

It's in Linus's tree now, and will be in the next 3.0.y stable release.

thanks,

greg k-h
