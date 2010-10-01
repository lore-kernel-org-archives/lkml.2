Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0JASm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:42:28 -0400
Received: from kroah.org ([198.145.64.141]:39482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab0JASm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:42:27 -0400
Date: Fri, 1 Oct 2010 11:26:41 -0700
From: Greg KH <greg@kroah.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kyle McMartin <kyle@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        stable@kernel.org, James Dingwall <james.dingwall@amdocs.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [stable] PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just
 after the boot
Message-ID: <20101001182641.GA9588@kroah.com>
References: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com>
 <20100927024044.GQ13116@bombadil.infradead.org>
 <20100927061336.GA22721@kroah.com>
 <4CA0DDAB.9090507@goop.org>
 <20100928182910.GA32464@kroah.com>
 <4CA35FB7.10600@goop.org>
 <20100930000644.GA26380@kroah.com>
 <4CA61080.6070709@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA61080.6070709@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 09:46:56AM -0700, Jeremy Fitzhardinge wrote:
>  On 09/29/2010 05:06 PM, Greg KH wrote:
> > On Wed, Sep 29, 2010 at 08:48:07AM -0700, Jeremy Fitzhardinge wrote:
> >>
> >> I should have pointed out it is the same in the stable-2.6.32 tree as well.
> > Yes, sorry, I know, I only had the chance to get the .35 release out
> > yesterday, I'll do the .32 one now.
> >
> 
> Ping?  Looks like the fix hasn't hit stable-2.6.32/master yet.

No it hasn't, sorry.  Turns out the Embedded Linux kernel "summit" was
too interesting to get a stable kernel out during it, and I've been in a
train/plane/train/ferry/taxi/bed since then.

Should now be out in a few hours...

thanks,

greg k-h
