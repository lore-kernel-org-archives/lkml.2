Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab0DHUq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:46:29 -0400
Received: from kroah.org ([198.145.64.141]:45727 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933229Ab0DHUq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:46:26 -0400
Date: Thu, 8 Apr 2010 13:46:13 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>
Subject: Re: [PATCH] staging/dt3155: fix build error caused by
 {write|read}l change
Message-ID: <20100408204613.GA25396@kroah.com>
References: <201003031124.06345.hartleys@visionengravers.com>
 <20100408191123.GB31571@kroah.com>
 <0D753D10438DA54287A00B0270842697636D3679E8@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B0270842697636D3679E8@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 03:38:06PM -0500, H Hartley Sweeten wrote:
> On Thursday, April 08, 2010 12:11 PM, Greg KH wrote:
> > On Wed, Mar 03, 2010 at 11:24:06AM -0700, H Hartley Sweeten wrote:
> >> This fixes a build error caused by replacing {Write | Read}MReg with 
> >> {write | read}l.
> >
> > Ick, can you merge this with your other patch so we don't have build
> > errors?  I just hit this and I had to drop all of your patches.
> 
> I was expecting you to NAK all of them anyway after I saw all the code 
> cleanup patches coming in on LKML.
> 
> > Can you respin all of them please?
> 
> Not a problem.  Are you planning on merging any of the dt3155 cleanup
> patches?  If so I will wait until they show up.

I took some, you should have gotten the responses now.

> Also, should staging patches be based on linux-next or on Linus' git tree?

linux-next please.

thanks,

greg k-h
