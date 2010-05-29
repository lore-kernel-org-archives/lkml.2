Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab0E2QgO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 12:36:14 -0400
Received: from kroah.org ([198.145.64.141]:56687 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348Ab0E2QgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 12:36:10 -0400
Date: Sat, 29 May 2010 09:36:00 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] zram: generic RAM based compressed R/W block
 devices
Message-ID: <20100529163600.GA5473@kroah.com>
References: <1274710685-2351-1-git-send-email-ngupta@vflare.org>
 <4BFFEA95.9040505@vflare.org>
 <20100528162657.GA28781@kroah.com>
 <4C006C11.7030309@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C006C11.7030309@vflare.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 06:51:21AM +0530, Nitin Gupta wrote:
> On 05/28/2010 09:56 PM, Greg KH wrote:
> > On Fri, May 28, 2010 at 09:38:53PM +0530, Nitin Gupta wrote:
> >> Hi All,
> >>
> >> On 05/24/2010 07:48 PM, Nitin Gupta wrote:
> >>> Creates RAM based block devices: /dev/zramX (X = 0, 1, ...).
> >>> Pages written to these disks are compressed and stored in memory
> >>> itself. These disks allow very fast I/O and compression provides
> >>> good amounts of memory savings.
> >>>
> >>> This is enhancement over existing ramzswap driver which creates
> >>> virtual block devices (/dev/ramzswapX) which could be used only
> >>> as swap disks.
> >>>
> >>> Now, with the ability to handle any kind of I/O request, zram
> >>> devices have lot more use cases:
> >>>  - /tmp storage
> >>>  - various caches under /var
> >>>  - swap disks
> >>>  - maybe even more! :)
> >>>
> >>> Performance numbers can be found at:
> >>> http://code.google.com/p/compcache/wiki/zramperf
> >>>
> >>
> >> Any reviews/comments, please?
> > 
> > We are all busy with the .35-rc1 merge work at the moment, sorry.
> > 
> 
> Thanks for your reply.
> 
> Ok, in the meantime, I will further test it and keep building upon it.
> When rc1 workload is over, I think all this can be merged in linux-next?

Yes, I think so.  It is in my queue to do so.

thanks,

greg k-h
