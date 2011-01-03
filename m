Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1ACRw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:52:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41212 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab1ACRw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:52:57 -0500
Date: Mon, 3 Jan 2011 10:52:54 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org
Subject: Re: [sodaville] [PATCH 02/11] x86: Add device tree support
Message-ID: <20110103175254.GD2522@angua.secretlab.ca>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
 <1290706801-7323-3-git-send-email-bigeasy@linutronix.de>
 <1290807736.32570.143.camel@pasglop>
 <20101128134907.GA30784@www.tglx.de>
 <20101230082654.GB11721@angua.secretlab.ca>
 <AANLkTin2=T=v0ZNOpAGhwuM0i9Ts8Xr+kRtEJ95VGeOp@mail.gmail.com>
 <AANLkTinSr_KYkFNUmWbL2PUzS2Ose7cA5q8xUbLeUr=J@mail.gmail.com>
 <4D21F3DB.90504@linux.intel.com>
 <4D21F718.8010600@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D21F718.8010600@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 08:19:36AM -0800, H. Peter Anvin wrote:
> On 01/03/2011 08:05 AM, H. Peter Anvin wrote:
> > On 12/30/2010 12:58 PM, Grant Likely wrote:
> >>
> >> Right, but in all of those cases a boot wrapper provides the same
> >> functionality with better flexability, such as being able to provided
> >> the dtb image(s) at install time instead of compile time.
> >>
> > 
> > Assuming the boot wrapper is written correctly.  I have seen a number of
> > cases in which it was not, and it being "already locked into firmware"
> > and not changeable.
> > 
> > It's a nice theory.  And in theory, theory and practice agree.
> > 
> 
> By the way, this is the same reason we also allow the initramfs and even
> the command line to be compiled in.

I think we've got an impedance mismatch.

The whole point of the ppc boot wrapper, and the kind of boot wrapper
that I'm talking about here, is that it becomes part of the kernel
image and is *not* part of firmware.  ie. an executable wrapper which
carries the kernel as it's payload.  I'm wary too of depending of
firmware to get things right because it can be so painful to change.

g.
