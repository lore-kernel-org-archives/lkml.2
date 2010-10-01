Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0JATRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 15:17:21 -0400
Received: from kroah.org ([198.145.64.141]:50716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab0JATRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 15:17:19 -0400
Date: Fri, 1 Oct 2010 12:16:11 -0700
From: Greg KH <greg@kroah.com>
To: Mike Galbraith <efault@gmx.de>
Cc: stable <stable@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix 2.6.32.23 suspend regression caused by commit
 6f6198a
Message-ID: <20101001191611.GA5259@kroah.com>
References: <1285907236.7425.42.camel@marge.simson.net>
 <1285909451.7425.49.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285909451.7425.49.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 07:04:11AM +0200, Mike Galbraith wrote:
> Again, with a less bouncy address.
> 
> From: Mike Galbraith <efault@gmx.de>
> Date: Fri, 1 Oct 2010 05:57:59 +0200
> Subject: [PATCH] fix 2.6.32.23 suspend regression caused by commit
> 6f6198a
> 
> 6f6198a sched: kill migration thread in CPU_POST_DEAD instead of
> CPU_DEAD
> leaves migration threads lying about.  Mask out CPU_TASKS_FROZEN.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>

Is this patch upstream already?  If so, what's the git commit id of it?
If not, why isn't it also needed there?

thanks,

greg k-h
