Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab1A1PVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:21:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1A1PVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:21:15 -0500
Date: Fri, 28 Jan 2011 07:15:55 -0800
From: Greg KH <gregkh@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, cota@braap.org,
        martyn.welch@ge.com
Subject: Re: [git patch] Delete zero-length file
Message-ID: <20110128151555.GA5199@suse.de>
References: <20110128083118.GA20804@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128083118.GA20804@havoc.gtf.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 03:31:18AM -0500, Jeff Garzik wrote:
> 
> Please pull from 'zerolen' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git zerolen
> 
> to receive the following updates:
> 
>  0 files changed, 0 insertions(+), 0 deletions(-)
>  delete mode 100644 drivers/staging/vme/bridges/Module.symvers
> 
> Jeff Garzik (1):
>       Delete zero-length drivers/staging/vme/bridges/Module.symvers
> 
> diff --git a/drivers/staging/vme/bridges/Module.symvers b/drivers/staging/vme/bridges/Module.symvers
> deleted file mode 100644
> index e69de29..0000000

Heh, yes, that's in my staging-linus tree already which will be going to
Linus later today.  Sorry, I've been on the road all week, which has
kept me from being able to send it off.

thanks,

greg k-h
