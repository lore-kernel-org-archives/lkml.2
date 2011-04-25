Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab1DYU7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:59:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:50497 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757734Ab1DYU7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:59:50 -0400
Date: Mon, 25 Apr 2011 13:33:39 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tino Keitel <tino.keitel@tikei.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM / Wakeup: Fix initialization of wakeup-related device
 sysfs files
Message-ID: <20110425203339.GA21375@suse.de>
References: <201104212357.43052.rjw@sisk.pl>
 <20110425195811.GA3407@mac.home>
 <201104252210.16719.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104252210.16719.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 10:10:16PM +0200, Rafael J. Wysocki wrote:
> On Monday, April 25, 2011, Tino Keitel wrote:
> > Hi,
> > 
> > the patch works fine on top of current git
> > (8f7544682c488dfc4117b37ed10435bb2d3d8d73). Wakeup using the keyboard
> > works.
> 
> Great, thanks for testing.
> 
> Greg, are you fine with https://lkml.org/lkml/2011/4/21/404 ?

Yes, very much so, sorry for not giving my ack before:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>


thanks,

greg k-h
