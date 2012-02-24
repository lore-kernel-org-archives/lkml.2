Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab2BXRKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:10:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35326 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab2BXRKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:10:53 -0500
Date: Fri, 24 Feb 2012 17:10:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
Message-ID: <20120224171050.GY23916@ZenIV.linux.org.uk>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
 <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
 <20120224153811.GA16535@kroah.com>
 <CAG4AFWaDxK2r9W7eehAnWHxD92C_fjpL1OQnENuZFjOjXDOYmA@mail.gmail.com>
 <20120224165448.GA8751@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224165448.GA8751@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 08:54:48AM -0800, Greg KH wrote:

> > As to "Linux isn't a microkernel", even though the debate between
> > Linux and microkernel have never stopped,
> 
> Um, who is having such a debate?  We aren't, so I don't think the debate
> has ever started.
> 
> > it's hard to deny the fact that Linux is slowly slowly moving towards
> > a microkernel structure: LKM, fuse, uio, etc.
> 
> "LKM", what do you mean by that?

At a guess, modules.  As to WTF would those possibly have to do with
microkernels, your guess is as good as mine...
