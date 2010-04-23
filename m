Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0DWTNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:13:10 -0400
Received: from kroah.org ([198.145.64.141]:41312 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab0DWTNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:13:06 -0400
Date: Fri, 23 Apr 2010 12:11:54 -0700
From: Greg KH <greg@kroah.com>
To: Evan McClain <evan.mcclain@gatech.edu>
Cc: Willy Tarreau <w@1wt.eu>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable-review@kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [051/197] backlight: mbp_nvidia_bl -
 add five more MacBook variants
Message-ID: <20100423191153.GA7345@kroah.com>
References: <20100422191857.GA13268@kroah.com>
 <20100422190911.935042749@kvm.kroah.org>
 <20100422195413.GA10849@macbook.site>
 <20100423160227.GB8048@suse.de>
 <20100423164945.GA21696@macbook.site>
 <20100423170542.GA21977@macbook.site>
 <20100423171102.GB14832@1wt.eu>
 <20100423180452.GA3112@macbook.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100423180452.GA3112@macbook.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 02:04:52PM -0400, Evan McClain wrote:
> On Fri, Apr 23, 2010 at 07:11:02PM +0200, Willy Tarreau wrote:
> > I'm not sure I understand the implications either. The real question in
> > my opinion is : is it better to keep this patch, to delay it or to drop
> > it ?
> 
> I'm afraid I'm not familiar with this whole process, but if the
> intention of the stable review is to only include perfectly correct
> code, I would suggest delaying until Steffen Röcker's patch could be
> included too.
> 
> As my patch currently stands, it will add support for only four of the 
> claimed five MacBook models. Unless some other machine reports a product 
> name of MacBook1,1 and a vendor of Apple Inc. and doesn't use an intel 
> graphics card there should be no real issues with the patch as it stands 
> other than claiming to support MacBook1,1.

It's ok, we'll leave the patch as-is.

thanks,

greg k-h
