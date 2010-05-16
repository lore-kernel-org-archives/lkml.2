Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0EPQZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 12:25:20 -0400
Received: from kroah.org ([198.145.64.141]:51909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0EPQZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 12:25:18 -0400
Date: Sun, 16 May 2010 09:21:50 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ramzswap: Remove backing swap support
Message-ID: <20100516162150.GA12062@kroah.com>
References: <1273740861-1900-1-git-send-email-ngupta@vflare.org> <AANLkTilmMKWbnVjbSIp-owEG1wUsARdg8SvpoEjJNUJY@mail.gmail.com> <4BF012B2.6080602@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF012B2.6080602@vflare.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 09:13:46PM +0530, Nitin Gupta wrote:
> Hi Minchan,
> 
> On 05/16/2010 09:50 AM, Minchan Kim wrote:
>  
> > One thing was about naming.
> > Now block device operations has field naming swap_xxx_notify
> > (I am not sure exact name). My concern was it's very specific about swap.
> > So I thought we would be better to more abstract name.
> >
> > I thought trim like naming as Linus said.
> 
> This call is very swap specific and is quite different from generic trim
> stuff. So, I think it will be better not be generalize the name and avoid
> confusing it with trim/discard etc.
> 
> > 
> > Anyway, I will review again at next week if it isn't merged
> > linux-next(or linux-mm ?? which is right?). That's because I have a
> > interest in your good ramzswap. :)
> > 
> 
> Thanks, comments/reviews are always welcome :)
> 
> Greg: In the meantime, considering 3 Acks, is it possible to pull it in
> linux-next?

It's already there, right?

thanks,

greg k-h
