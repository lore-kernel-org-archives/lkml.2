Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0IQREL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 13:04:11 -0400
Received: from kroah.org ([198.145.64.141]:43398 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab0IQREK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 13:04:10 -0400
Date: Fri, 17 Sep 2010 10:01:49 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, drosenberg@vsecurity.com
Subject: Re: [PATCH 0/3] Fix the TIOCGICOUNT problem for good
Message-ID: <20100917170149.GB13570@kroah.com>
References: <20100916171747.25987.33573.stgit@localhost.localdomain>
 <20100916.215639.172549193.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916.215639.172549193.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 09:56:39PM -0700, David Miller wrote:
> From: Alan Cox <alan@linux.intel.com>
> Date: Thu, 16 Sep 2010 18:21:06 +0100
> 
> > Remembering to clear fields is something driver authors are simply never
> > going to remember to get right every new driver. Instead take the problem
> > away from them and give them a simple interface to do the job.
> > 
> > ---
> > 
> > Alan Cox (3):
> >       tty: icount changeover for other main devices
> >       tty: Convert the USB drivers to the new icount interface
> >       tty: Make tiocgicount a handler
> 
> This is a good plan for the next merge window, but for the current
> -rc series and -stable we'd better just fix the individual cases.

Agreed, that's the plan now.

thanks,

greg k-h
