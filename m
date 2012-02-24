Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab2BXBha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:37:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:39826 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756937Ab2BXBh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:37:29 -0500
Message-ID: <1330047437.20389.40.camel@pasglop>
Subject: Re: [PATCH] tty: the briq panel isn't a tty, make it use its own
 locking
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 24 Feb 2012 12:37:17 +1100
In-Reply-To: <20120223225602.747c31df@pyramind.ukuu.org.uk>
References: <20120223133931.6227.89653.stgit@bob.linux.org.uk>
	 <1330029747.20389.37.camel@pasglop>
	 <20120223225602.747c31df@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 22:56 +0000, Alan Cox wrote:
> > Hrm, I don't think anybody maintains it but I do have a BriQ somewhere
> > in storage, so I suppose I could pick it up, not that I need another
> > crap driver to deal with right now though...
> 
> In which case can we just stuff it into the tree, or take the briq driver
> out into staging as this is the last blocker on tackling the tty_lock
> entirely in the tty layer 

Just remove the driver, I don't think anybody cares.

Cheers,
Ben.


