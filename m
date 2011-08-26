Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1HZVok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:44:40 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58274 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755521Ab1HZVoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:44:39 -0400
X-Sasl-enc: Wqq3ay8MosfvBY3EYdGhe+01eqCXovJlm4yTxf0XMtwV 1314395078
Date: Fri, 26 Aug 2011 14:43:29 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
Message-ID: <20110826214329.GA6325@kroah.com>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 04:15:10PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Reposting due to popular demand. Several other people are running
> into the same problem with all kinds of software.
> 
> Only change is rebase against current master.
> 
> -Andi
> 
> --
> 
> I ran into a couple of programs which broke with the new Linux 3.0 version.
> Some of those were binary only. I tried to use LD_PRELOAD to work
> around it, but it was quite difficult and in one case impossible
> because of a mix of 32bit and 64bit executables.
> 
> This patch adds a UNAME26 personality that makes the kernel
> report a 2.6.40+x version number instead. The x is the x in 3.x.
> 
> I know this is somewhat ugly, but I didn't find a better workaround,
> and compatibility to existing programs is important.
> 
> Some programs also read /proc/sys/kernel/osrelease. This can be worked
> around in user space with mount --bind (and a mount namespace)
> 
> To use:
> 
> wget ftp://ftp.kernel.org/pub/linux/kernel/people/ak/uname26/uname26.c
> gcc -o uname26 uname26.c
> ./uname26 program

I hate to ask, but can you put a proper copyright and license on this
file so that distros can distribute it?

thanks,

greg k-h
