Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031036Ab2CIUl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:41:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60318 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030569Ab2CIUlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:41:55 -0500
Date: Fri, 9 Mar 2012 12:41:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@hack.frob.com>
Subject: Re: [ 17/68] regset: Return -EFAULT, not -EIO, on host-side memory
 fault
Message-ID: <20120309204150.GA2125@kroah.com>
References: <20120309194409.GA2069@kroah.com>
 <20120309190216.344083722@linuxfoundation.org>
 <20120309203446.GB23244@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309203446.GB23244@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 02:34:46PM -0600, Jonathan Nieder wrote:
> Greg KH wrote:
> 
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: "H. Peter Anvin" <hpa@zytor.com>
> >
> > commit 5189fa19a4b2b4c3bec37c3a019d446148827717 upstream.
> >
> > There is only one error code to return for a bad user-space buffer
> > pointer passed to a system call in the same address space as the
> > system call is executed, and that is EFAULT.
> 
> I don't think this has the potential to cause regressions, and it
> certainly makes things saner, so from that point of view it looks
> good.

"making things sane" is good enough for me :)

> Part of the reason I am asking is to figure out whether the patch
> ought to be applied to 2.6.32.y, too.

Why do you think it should not be?

thanks,

greg k-h
