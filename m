Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2DMRlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:41:15 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49512 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2DMRlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:41:14 -0400
Date: Fri, 13 Apr 2012 10:41:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Miller <davem@davemloft.net>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        alan@linux.intel.com, andrea@persephoneslair.org
Subject: Re: [PATCH 1/3] NET: pc300, move to staging as it is broken
Message-ID: <20120413174109.GA32536@kroah.com>
References: <1334135699-30180-1-git-send-email-jslaby@suse.cz>
 <20120413.133533.212991624580049561.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413.133533.212991624580049561.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 01:35:33PM -0400, David Miller wrote:
> From: Jiri Slaby <jslaby@suse.cz>
> Date: Wed, 11 Apr 2012 11:14:57 +0200
> 
> > It was marked as BROKEN back in 2008. It is because the tty handling
> > in the driver is really broken.
> > 
> > There was some activity in January 2012 to fix the driver, but the
> > patch was commented to be bogus:
> >   https://lkml.org/lkml/2012/1/29/160
> > and we have not heard back from the author since then:
> >   https://lkml.org/lkml/2012/3/28/412
> > 
> > So since nobody stepped in and rewrote the driver, it is time to move
> > it out of line now. And drop it some time later if nobody comes up
> > with patches to fix the driver in staging.
> > 
> > Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> 
> No objections, I'll let the staging guy handle this :-)
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks, I will :)
