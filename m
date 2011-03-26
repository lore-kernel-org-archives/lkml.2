Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab1CZPJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 11:09:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:56536 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab1CZPJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 11:09:54 -0400
Date: Sat, 26 Mar 2011 08:10:50 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        vapier@gentoo.org
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Message-ID: <20110326151050.GA27822@suse.de>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <201103252301.56718.arnd@arndb.de>
 <20110325232847.GA5551@suse.de>
 <201103261225.03504.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103261225.03504.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 12:25:03PM +0100, Arnd Bergmann wrote:
> On Saturday 26 March 2011 00:28:47 Greg KH wrote:
> 
> > Yes, that is how it used to be, but then it turns out that both of them
> > are really just "subsystems" as far as it all goes.  They are just ways
> > that devices are bound to drivers in a logical manner.  We have patches
> > floating around that get rid of both busses and classes to merge them
> > together, which is the end goal here.  I know Kay has posted detailed
> > reasons for why this all is on lkml in the past, and had working code
> > about 5 years ago, it's just been slow going...
> 
> How will that work? I suppose we can't really change the directory
> structure anyway, so to users it will still look like it does today,
> even if the kernel just uses the same code for bus and class internally.

Yes.  But we can have symlinks instead of "real" /sys/class and
/sys/bus directories like we do for /sys/block today.  All of the major
tools that use sysfs work properly with a /sys/subsystem/ setup today
thanks to Kay's efforts.

thanks,

greg k-h
