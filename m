Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab0FVXFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:05:10 -0400
Received: from kroah.org ([198.145.64.141]:44454 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab0FVXFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:05:05 -0400
Date: Tue, 22 Jun 2010 16:04:28 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH v2] Staging: dt3155: Cleanup memory mapped i/o access
Message-ID: <20100622230428.GA2854@kroah.com>
References: <0D753D10438DA54287A00B0270842697636EB83CE8@AUSP01VMBX24.collaborationhost.net>
 <20100504201207.GA7096@kroah.com>
 <0D753D10438DA54287A00B0270842697636EB83E2A@AUSP01VMBX24.collaborationhost.net>
 <20100504210229.GA21128@kroah.com>
 <0D753D10438DA54287A00B0270842697636EB83EC9@AUSP01VMBX24.collaborationhost.net>
 <0D753D10438DA54287A00B0270842697636ECB4D7B@AUSP01VMBX24.collaborationhost.net>
 <20100506202535.GA28600@kroah.com>
 <0D753D10438DA54287A00B027084269763715265FE@AUSP01VMBX24.collaborationhost.net>
 <20100622223913.GA28119@kroah.com>
 <0D753D10438DA54287A00B027084269763716504D6@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269763716504D6@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 05:45:32PM -0500, H Hartley Sweeten wrote:
> On Tuesday, June 22, 2010 3:39 PM, Greg KH wrote:
> > You are still doing something odd, this one doesn't apply either.  Is
> > your email client messing something up?
> >
> > strange.
> 
> Hmm. I thought I had that worked out since I haven't had any problems lately.
> 
> Can you please try this one?

Nope, I get the following errors:


>tching file drivers/staging/dt3155/dt3155_drv.c
Hunk #2 FAILED at 112.
Hunk #7 succeeded at 214 with fuzz 2.
Hunk #8 succeeded at 234 with fuzz 2.
Hunk #9 FAILED at 252.
Hunk #10 succeeded at 260 with fuzz 2.
Hunk #12 succeeded at 313 with fuzz 2.
Hunk #13 FAILED at 390.
Hunk #14 succeeded at 405 with fuzz 2.
Hunk #16 FAILED at 433.
Hunk #17 FAILED at 451.
Hunk #22 succeeded at 915 with fuzz 1.
Hunk #23 succeeded at 1040 with fuzz 2.
5 out of 23 hunks FAILED -- saving rejects to file drivers/staging/dt3155/dt3155_drv.c.rej
patching file drivers/staging/dt3155/dt3155_drv.h
patching file drivers/staging/dt3155/dt3155_io.c
Hunk #2 FAILED at 77.
Hunk #3 FAILED at 103.
Hunk #4 FAILED at 119.
Hunk #5 FAILED at 134.
Hunk #6 FAILED at 151.
5 out of 6 hunks FAILED -- saving rejects to file drivers/staging/dt3155/dt3155_io.c.rej
patching file drivers/staging/dt3155/dt3155_io.h
Reversed (or previously applied) patch detected!  Assume -R? [n] 

not good...

thanks,

greg k-h
