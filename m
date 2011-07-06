Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab1GFTeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:34:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab1GFTeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:34:20 -0400
Date: Wed, 6 Jul 2011 12:26:56 -0700
From: Greg KH <gregkh@suse.de>
To: Prashant Shah <pshah.mumbai@gmail.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: msm: fixed style issues found by checkpatch.pl
Message-ID: <20110706192656.GA30532@suse.de>
References: <20110706074934.GA935@mail.fossee.in>
 <20110706155745.GB16625@suse.de>
 <CAD6i1fK0nH+D3v+A3erC1PgR=S=709H9ZC=T8-q0gqV1ghA0bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD6i1fK0nH+D3v+A3erC1PgR=S=709H9ZC=T8-q0gqV1ghA0bQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 09:45:08PM +0530, Prashant Shah wrote:
> Hi,
> 
> > So that would be one patch for fixing extra braces, one for extra
> > spaces, and so on.  That makes it easier to review.
> 
> Ok I will redo them.
> 
> On Wed, Jul 6, 2011 at 9:27 PM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Jul 06, 2011 at 01:19:34PM +0530, Prashant P. Shah wrote:
> > Also, did you successfully build this code before and after your
> > changes?
> 
> I tried but the code does not build because of #include <mach/board.h>
> in the msm_fb.c file. I dont know how to fix that.

I say let's just delete this whole directory as if it doesn't build, no
one is using it, and no one has tried to clean it up since it was
originally added.

Stepan or David or Abhijeet or Daniel, any objection to just deleting
drivers/staging/msm/ at this point in time for the 3.1 kernel release?
You haven't sent any patches to me to clean this code up since the
original patch, way over a year ago.

greg k-h
