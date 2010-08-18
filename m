Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0HRNfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:35:38 -0400
Received: from kroah.org ([198.145.64.141]:59050 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab0HRNfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:35:36 -0400
Date: Wed, 18 Aug 2010 06:34:59 -0700
From: Greg KH <greg@kroah.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.2 regression, does not boot, sleeping function called
	from invalid context
Message-ID: <20100818133459.GA6663@kroah.com>
References: <20100817145305.GA7342@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817145305.GA7342@linux-m68k.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 04:53:05PM +0200, Richard Zidlicky wrote:
> Hi,
> 
> updated 2.6.35 -> 2.6.35.2 and it breaks very early during initialisation, does
> not boot.
> 
> The first oops I get is a ~BUG sleeping function called from invalid context, mm/rmap.c:119~
> Comes right after 
>   protecting the kernel read only data: 1868K
> 
> Backtrace seems to be 
>   anon_vma_prepare
>   do_raw_spinlock
>   expand_downwards
> 
> I can email pictures of stack back trace off list if anyone is interested.
> 2.6.35 works without problems except that hibernation is completely broken,
> attached dmesgs for 2.6.35

Does .35.1 work?

.35.2 has some issues that are being worked on, the patches to solve the
bug is already in Linus's tree, give me a few days to get a new release
out with this solved.

thanks,

greg k-h
