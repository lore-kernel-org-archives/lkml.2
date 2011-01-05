Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab1AEWRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 17:17:55 -0500
Received: from kroah.org ([198.145.64.141]:45583 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab1AEWRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 17:17:54 -0500
Date: Wed, 5 Jan 2011 13:18:47 -0800
From: Greg KH <greg@kroah.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] staging: tidspbridge for 2.6.38
Message-ID: <20110105211847.GA16229@kroah.com>
References: <1293178543-7556-1-git-send-email-omar.ramirez@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293178543-7556-1-git-send-email-omar.ramirez@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 02:15:43AM -0600, Omar Ramirez Luna wrote:
> Hi Greg,
> 
> This is the first pull request of changes for tidspbridge driver for 2.6.38,
> I expect to make another request with at least one bug fix, but in the mean
> time here it is the content for this one:
> 
> The following changes since commit 90a8a73c06cc32b609a880d48449d7083327e11a:
> 
>   Linux 2.6.37-rc7 (2010-12-21 11:26:40 -0800)
> 
> are available in the git repository at:
>   git://dev.omapzoom.org/pub/scm/tidspbridge/kernel-dspbridge.git dspbridge

Ick, no.  Why did you base this on -rc7?  My staging-next branch is
based on -rc5 at the moment, and I really see no need to merge the rest
of them into the tree for no good reason at all.

Also, as you did send this before the merge window closed, but during
the holidays, I couldn't get to it.  But in looking at this, it's going
to have to wait for the next window, sorry, it's just too big, and too
late.  You weren't expecting me to be working on kernel stuff during my
holiday break, were you?

So, feel free to redo this against 2.6.38-rc1 when that comes out.

thanks,

greg k-h
