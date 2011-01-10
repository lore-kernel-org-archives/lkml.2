Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1AJXNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:13:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:46113 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1AJXNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:13:12 -0500
Date: Mon, 10 Jan 2011 14:56:18 -0800
From: Greg KH <gregkh@suse.de>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.28
Message-ID: <20110110225618.GA27939@suse.de>
References: <20110107234939.GA18703@kroah.com>
 <20110110223657.GA13083@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110223657.GA13083@elliptictech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 05:36:57PM -0500, Nick Bowler wrote:
> On 2011-01-07 15:49 -0800, Greg KH wrote:
> > I'm announcing the release of the 2.6.32.28 kernel.
> > 
> > All users of the 2.6.32 kernel series must upgrade.
> > 
> > The updated 2.6.32.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
> > and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary
> 
> Would it be possible to make an amalgamated -longterm git tree
> containing a branch for each longterm kernel like we currently
> have for -stable (stable/linux-2.6-stable.git)?

That is an automatically generated tree, it is on the todo list for
people to look at implementing sometime soon.  But as I am not the one
doing it, I really can't say when it will happen.

thanks,

greg k-h
