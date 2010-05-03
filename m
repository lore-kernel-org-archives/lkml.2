Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab0ECTLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:11:47 -0400
Received: from kroah.org ([198.145.64.141]:49358 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab0ECTLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:11:38 -0400
Date: Mon, 3 May 2010 11:48:32 -0700
From: Greg KH <greg@kroah.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, penberg@cs.helsinki.fi, pavel@ucw.cz,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35tx.c Coding style fixes.
Message-ID: <20100503184832.GA10862@kroah.com>
References: <1269764725-10190-1-git-send-email-lindley@coyote.org>
 <20100429160630.GA8710@kroah.com>
 <4BDD3C4F.7030500@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BDD3C4F.7030500@coyote.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 02, 2010 at 10:48:15AM +0200, Lars Lindley wrote:
> On 2010-04-29 18:06, Greg KH wrote:
> > On Sun, Mar 28, 2010 at 10:25:25AM +0200, Lars Lindley wrote:
> >> I fixed the problems reported by checkpatch.pl except some long
> >> lines and printk:s.
> >> I also removed versioning comments.
> >> Builds fine, .o identical to before and checked it with
> >> Dan Carpenters strip_whitespace.pl and diff.
> >>
> >> Signed-off-by: Lars Lindley <lindley@coyote.org>
> > 
> > This no longer applies on linux-next due to some upstream changes.  Can
> > you rediff it and resend it?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Ok, does this work better?

Close, but it still fails on the first chunk:
	patching file drivers/staging/winbond/wb35tx.c
	Hunk #1 FAILED at 1.
	Hunk #2 succeeded at 26 (offset 1 line).
	Hunk #3 succeeded at 65 (offset 1 line).
	Hunk #4 succeeded at 114 (offset 1 line).
	Hunk #5 succeeded at 125 (offset 1 line).
	Hunk #6 succeeded at 134 (offset 1 line).
	Hunk #7 succeeded at 201 (offset 1 line).
	Hunk #8 succeeded at 252 (offset 1 line).
	Hunk #9 succeeded at 264 (offset 1 line).
	Hunk #10 succeeded at 288 (offset 1 line).
	1 out of 10 hunks FAILED -- saving rejects to file drivers/staging/winbond/wb35tx.c.rej

Care to redo it on top of the linux-next tree?

thanks,

greg k-h
