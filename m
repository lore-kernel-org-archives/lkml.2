Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab0DVE0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 00:26:00 -0400
Received: from mail.perches.com ([173.55.12.10]:1673 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab0DVEZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 00:25:59 -0400
Subject: Re: What's the staging review and acceptance process?
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100422034532.GA25177@suse.de>
References: <1271881967.1730.482.camel@Joe-Laptop.home>
	 <20100422034532.GA25177@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 21:25:57 -0700
Message-ID: <1271910357.1730.627.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 20:45 -0700, Greg KH wrote:
> That caused the huge backlog staring at
> me right now.

Which likely discouraged the new contributors who
submitted stuff still in that backlog.

> I just went through 100 patches, and only 40 of them
> were "valid" and able to be applied, so it is a high rejection rate
> which requires a lot of attention to be paid to them.
> 
> > What is your current review/notify/accept/reject workflow?
> 
> Like it's always been:
>   - patch comes in
>   - I get around to reviewing it
>   - if valid, I apply and you get an email
>   - if invalid, I reject and say why in email

Unfortunately, your process has been opaque until you
personally handle it.

Does the driverdev list or any list always receive a copy
or the feedback?

> > Perhaps a patchwork queue for staging might help track these
> > patches and with more feedback or reviewers, get them in
> > shape to be applied.

> patchwork doesn't work well for my patch flow, but maybe that is because
> I haven't spent enough time with it.  Right now I have all the patches,
> it's just a matter of getting through them.

Maybe you should get some advice on using patchwork use
from somebody like David Miller, who gets rather more
patches for networking than staging gets.  The patchwork
queue for networking always seems managed and it can use
delegation, which your process doesn't seem capable of
doing.  You're a voluntary bottleneck for staging, I
think you either need to find personal cycles or find
some other suckers willing to volunteer who'd make up
more overall cycles.

cheers, Joe

