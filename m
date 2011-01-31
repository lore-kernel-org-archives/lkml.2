Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1AaWRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:17:20 -0500
Received: from kroah.org ([198.145.64.141]:53643 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676Ab1AaWRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:17:18 -0500
Date: Mon, 31 Jan 2011 14:16:59 -0800
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <bp@amd64.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/7] sysdev: Do not register with sysdev when erroring
 on add
Message-ID: <20110131221659.GA14918@kroah.com>
References: <1295882943-11184-1-git-send-email-bp@amd64.org>
 <1295882943-11184-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295882943-11184-2-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 04:28:57PM +0100, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> When encountering an error while executing the driver's ->add method, we
> should cancel registration and unwind what we've regged so far. The low
> level ->add methods do return proper error codes but those aren't looked
> at in sysdev_driver_register(). Fix that by sharing the unregistering
> code.

Have you actually hit this before?  If so, where?

> Also, fixup warning messages formatting while at it.

Please, no, one patch per thing.  Please break this up into two
different patches.

And, in the future, let me know that you need this for other work.
Actually, why did you send this to Ingo in your pull request?  What does
your microcode patches need from this patch?  It should go through my
tree, especially as there is other sysdev work happening at the moment.

so, no, please don't send this on to anyone else right now.

thanks,

greg k-h
