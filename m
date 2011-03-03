Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1CCGVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:21:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab1CCGVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:21:52 -0500
Date: Wed, 2 Mar 2011 22:04:48 -0800
From: Greg KH <gregkh@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ted Ts'o" <tytso@mit.edu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>, dj@deadhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: Why is my copyright code in the linux kernel?
Message-ID: <20110303060448.GB32209@suse.de>
References: <ded07e5c09d72da478c6218658095f5a.squirrel@deadhat.com>
 <AANLkTimg1x56B4Yu=Zsd0VEci2i4jRKaMU+gxv3oFVr8@mail.gmail.com>
 <20110301235433.GD2959@thunk.org>
 <4D6EBC04.5050709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6EBC04.5050709@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 01:52:04PM -0800, H. Peter Anvin wrote:
> On 03/01/2011 03:54 PM, Ted Ts'o wrote:
> > On Wed, Mar 02, 2011 at 12:30:45AM +0100, richard -rw- weinberger wrote:
> >>> You will see a remarkable resemblance to parts of
> >>> linux-2.6.36.2/drivers/staging/rt2860/common/cmm_aes.c. E.G. the AES code,
> >>
> >> please note, this is a staging driver.
> > 
> > It's not even the primary driver.  Is there anything that this driver
> > provides that isn't provided by the upstream supported, mainline
> > rt2x00 project?  I.e., can we just delete the staging driver?
> > 
> > If we are going to keep the staging driver for some reason, one of the
> > things that should be added to the TODO list would be delete its
> > driver-specific AES code and replace it with calls to the kernel's
> > generic AES code, which among other things, has the advantage that it
> > can take advantage of the AES-NI instructions provided on more modern
> > x86 CPU's.
> > 
> >>> I'd like to know who is an appropriate person to discuss this with.
> >>
> >> the code is from ralink.
> > 
> > David, you might want to contact ralink directly, since it's likely
> > they are distributing that driver with your AES code in other places
> > besides just in the mainstream kernel sources.  Even if we delete the
> > code in the staging tree, they might be distributing that driver still
> > via other means.
> > 
> 
> I think it's more fundamental than that.  If ralink -- or anyone else --
> submitted a plagiarized driver to the staging tree, we should remove it
> immediately unless the copyright holder (David in this case) is willing
> to allow us to retain it while things are sorted out.

The problem is the code is on a public web site that says "this code is
in the public domain."  I'm not going to go into the whole "what does
public domain really mean" argument here, but I think the people who
took that code and put it into their drivers have a valid assumption
that they did so properly.

thanks,

greg k-h
