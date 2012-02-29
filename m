Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2B2UV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:21:27 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:57262 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab2B2UV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:21:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.200.195 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Wed, 29 Feb 2012 12:21:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: the briq panel isn't a tty, make it use its own
 locking
Message-ID: <20120229202113.GA31780@kroah.com>
References: <20120223133931.6227.89653.stgit@bob.linux.org.uk>
 <1330029747.20389.37.camel@pasglop>
 <20120223225602.747c31df@pyramind.ukuu.org.uk>
 <1330047437.20389.40.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330047437.20389.40.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 12:37:17PM +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2012-02-23 at 22:56 +0000, Alan Cox wrote:
> > > Hrm, I don't think anybody maintains it but I do have a BriQ somewhere
> > > in storage, so I suppose I could pick it up, not that I need another
> > > crap driver to deal with right now though...
> > 
> > In which case can we just stuff it into the tree, or take the briq driver
> > out into staging as this is the last blocker on tackling the tty_lock
> > entirely in the tty layer 
> 
> Just remove the driver, I don't think anybody cares.

Wonderful, I'll go do that right now :)

greg k-h
