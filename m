Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab2BXRSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:18:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35430 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab2BXRSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:18:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.189.1 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 24 Feb 2012 09:17:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224171752.GB9485@kroah.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
 <20120224153811.GA16535@kroah.com>
 <1330103229.23014.130.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330103229.23014.130.camel@groeck-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 09:07:09AM -0800, Guenter Roeck wrote:
> How about dropping UIO support from the kernel ? That would make more
> sense to me.

Again, UIO solves a real need, are you to tell the users of that code
that somehow we are now not going to support them anymore?

UIO was created when Thomas and I sat in the back of a conference
presentation and saw, for the umpteenth time, a presentation by someone
who was trying to write userspace drivers, and obviously didn't know
what they were doing.

UIO provides a framework that actually works (unlike all of the previous
research papers were trying to do), and is used in real systems (laser
welding robots!) every day, manufacturing things that you use and rely
on.

You remove UIO at the risk of pissing off those robots, the choice is
yours, I know I'm not going to do it...

greg k-h
