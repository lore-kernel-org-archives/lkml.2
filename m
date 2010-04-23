Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab0DWRLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 13:11:25 -0400
Received: from 1wt.eu ([62.212.114.60]:63518 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758416Ab0DWRLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 13:11:22 -0400
Date: Fri, 23 Apr 2010 19:11:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: Evan McClain <evan.mcclain@gatech.edu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [051/197] backlight: mbp_nvidia_bl - add five more MacBook variants
Message-ID: <20100423171102.GB14832@1wt.eu>
References: <20100422191857.GA13268@kroah.com> <20100422190911.935042749@kvm.kroah.org> <20100422195413.GA10849@macbook.site> <20100423160227.GB8048@suse.de> <20100423164945.GA21696@macbook.site> <20100423170542.GA21977@macbook.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423170542.GA21977@macbook.site>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 01:05:43PM -0400, Evan McClain wrote:
> On Fri, Apr 23, 2010 at 12:49:46PM -0400, Evan McClain wrote:
> > On Fri, Apr 23, 2010 at 09:02:27AM -0700, Greg KH wrote:
> > > I don't understand, is this patch not correct?  Should I drop it from
> > > the stable release?
> > 
> > It is correct, but it will not match MacBook1,1s as intended due to
> > apple changing vendor names.
> 
> And by correct, I mean it would be correct if it only claimed to add
> four MacBook variants instead of five.

I'm not sure I understand the implications either. The real question in
my opinion is : is it better to keep this patch, to delay it or to drop
it ?

Willy

