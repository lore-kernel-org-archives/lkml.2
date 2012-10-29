Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab2J2XDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 19:03:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58408 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab2J2XDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 19:03:41 -0400
Date: Mon, 29 Oct 2012 16:03:37 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Lord <kernel@teksavvy.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yinghai Lu <yinghai@kernel.org>, Willy Tarreau <w@1wt.eu>,
        stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: Regression from 3.4.9 to 3.4.16 "stable" kernel
Message-ID: <20121029230337.GA22444@kroah.com>
References: <508E002B.4090200@teksavvy.com>
 <20121029064643.GE574@1wt.eu>
 <508E913D.2080104@teksavvy.com>
 <1351521658.13356.7.camel@deadeye.wl.decadent.org.uk>
 <20121029144722.GA23217@jshin-Toonie>
 <20121029165823.GA6614@kroah.com>
 <508F0AA6.6010702@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508F0AA6.6010702@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 07:00:54PM -0400, Mark Lord wrote:
> There's something else very wrong when going from 3.4.9 to 3.4.16.
> I've done it on two machines here, one the AMD-450 server (64-bit),
> and the other my main notebook (Core2duo 32-bit-PAE).
> 
> Both systems feel much more sluggish than usual with 3.4.16 running.
> Reverted them both back to earlier kernels (3.4.9, 3.4.4-PAE),
> and the usual responsive feel has returned.
> 
> Vague, I know, but something bad happened in there somewhere.

That's too vague for me to do anything with, sorry.  Bisection would be
good if you can figure out how to measure this.

greg k-h
