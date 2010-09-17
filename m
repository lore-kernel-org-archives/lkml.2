Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab0IQQh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 12:37:59 -0400
Received: from kroah.org ([198.145.64.141]:46048 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab0IQQh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:37:58 -0400
Date: Fri, 17 Sep 2010 09:36:36 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Palfrader <peter@palfrader.org>, stable@kernel.org,
        Huang Shijie <shijie8@gmail.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [stable] breaks 2.6.32.21+
Message-ID: <20100917163636.GA2916@kroah.com>
References: <1281261197-8816-1-git-send-email-shijie8@gmail.com>
 <4C5EA651.7080009@kernel.org>
 <20100916213603.GW6447@anguilla.noreply.org>
 <20100916231307.GB24617@kroah.com>
 <4C937177.1090909@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C937177.1090909@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 03:47:35PM +0200, Tejun Heo wrote:
> On 09/17/2010 01:13 AM, Greg KH wrote:
> > Odd, someone just reported the same problem for .35-stable as well.
> > 
> > Tejun, what's going on here?
> 
> Please drop it.  The memory leak was introduced after 2.6.36-rc1.  I
> got confused which commit was in which kernel.  I'll be more careful
> with stable cc's.  Sorry about that.

No problem, now dropped.

thanks,

greg k-h
