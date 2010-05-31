Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab0EaMzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 08:55:25 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:54376 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab0EaMzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 08:55:24 -0400
Date: Mon, 31 May 2010 22:55:23 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: David Miller <davem@davemloft.net>
cc: geert@linux-m68k.org, joe@perches.com, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] mac8390: change an error return code and some cleanup,
 take 4
In-Reply-To: <20100531.043056.258120791.davem@davemloft.net>
Message-ID: <alpine.OSX.2.00.1005312244520.1490@localhost>
References: <alpine.LNX.2.00.1005311905520.469@nippy.intranet> <AANLkTilkooBglbk33yDHmk8c_ZdlamOW8FVvuvjQaNsF@mail.gmail.com> <alpine.LNX.2.00.1005312011210.469@nippy.intranet> <20100531.043056.258120791.davem@davemloft.net>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 31 May 2010, David Miller wrote:

> From: fthain@telegraphics.com.au
> Date: Mon, 31 May 2010 21:07:09 +1000 (EST)
> 
> > Apparently David now wants me to submit this again --
> > 
> > if (ei_debug)
> > 	pr_debug(...)
> > 
> > David, if that code is acceptable, please let me know.
> 
> The only thing I care about is at the moment that you don't do something 
> that ends up dropping the pr_fmt prefix.
> 
> The pr_fmt define at the beginning of the driver is for nothing if we 
> end up adding exceptions that end up eliding it for no good reason.  
> And that's what your patch was doing.
> 

Since you have rejected my most recent patch submission, which uses pr_fmt 
explicitly, I imagine that what you are trying to say here is that only 
pr_debug or pr_info are acceptable.

Now, so that we don't have to go through pointless resubmission 
iterations, can you tell me which of the following you prefer:

if (ei_debug)
	pr_debug(...)

OR

if (ei_debug)
	pr_info(...)

Thanks.

Finn
