Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1CQAEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:04:22 -0400
Received: from kroah.org ([198.145.64.141]:48352 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1CQAEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:04:16 -0400
Date: Wed, 16 Mar 2011 17:04:08 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Bigler <stefan.bigler@keymile.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
Message-ID: <20110317000408.GA18911@kroah.com>
References: <4D8121F6.9060600@keymile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8121F6.9060600@keymile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 09:47:50PM +0100, Stefan Bigler wrote:
> Hi all
> 
> I'm facing a problem with TTY loosing data using u_serial gadget.
> 
> I have a MPC8247 based system running 2.6.33.

Oh, that's an old kernel, lots of work on the tty layer has happened
since then that would fix issues like this.

If you are stuck using this kernel, please go ask your vendor for
support for it.

If not, can you try out 2.6.38 and let us, and the
linux-usb@vger.kernel.org list know if you still have problems with it?

thanks,

greg k-h
