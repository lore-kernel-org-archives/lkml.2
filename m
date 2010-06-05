Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0FEClr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 22:41:47 -0400
Received: from kroah.org ([198.145.64.141]:52602 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab0FEClq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 22:41:46 -0400
Date: Fri, 4 Jun 2010 19:40:38 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: [GIT PATCH] STAGING fixes and new drivers for 2.6.35-git
Message-ID: <20100605024038.GA13792@kroah.com>
References: <20100604204455.GD19761@kroah.com>
 <alpine.LFD.2.00.1006041528291.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006041528291.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 03:30:40PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 4 Jun 2010, Greg KH wrote:
> >
> > Here are a number of bugfixes for the drivers/staging tree, as well as 3
> > new stand-alone drivers.  The new drivers kind of obscure the diffstat
> > showing the other fixes due to their size.
> 
> I pulled, but quite frankly, I don't want to see this kind of pull request 
> again. There's just no _point_. 
> 
> I'll take new drivers outside the merge window, but there has to be some 
> _reason_ for them. See the whole SCSI discussion a few merge windows ago. 
> The new driver needs to improve the life of somebody to the point where I 
> want to feel that there is a _reason_ for pulling it outside the merge 
> window.

Fair enough, I shouldn't have added them to the request this time,
sorry.

> These drivers? Not so much. Not even f*cking close.
> 
> In other words: tell me why the new drivers couldn't just have waited for 
> the next merge window? Really?

They could have, sorry, will not do it again.

greg k-h
