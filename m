Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab2DDUuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 16:50:01 -0400
Received: from stl-smtpout-01.boeing.com ([130.76.96.56]:65446 "EHLO
	stl-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab2DDUuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 16:50:00 -0400
X-Greylist: delayed 1185 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2012 16:50:00 EDT
Date: Wed, 4 Apr 2012 13:30:04 -0700
From: Tom Goff <thomas.goff@boeing.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] sysfs: Update the name hash for an entry after changing the namespace
Message-ID: <20120404203004.GA10737@boeing.com>
References: <6AFD35BEDB60334C9A31FD694E13EF0D22CFFA40B3@XCH-NW-18V.nw.nos.boeing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404192236.GA30172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 12:22:36 -0700, Greg Kroah-Hartman wrote:
> On Wed, Apr 04, 2012 at 12:06:20PM -0700, Tom Goff wrote:
> > This is needed to allow renaming network devices that have been moved
> > to another network namespace.
> > 
> > Signed-off-by: Tom Goff <thomas.goff@boeing.com>
> > ---
> >  fs/sysfs/dir.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Is this a bug in 3.4-rc1 and older kernels?  If so, how old?
> 
> thanks,
> 
> greg k-h

Yes, this is a bug in 3.4-rc1.  The patch is really a change to
d5c38b137ac8a6e3dbed13bc494d60df5b69dfc4 'sysfs: Update the name hash
when renaming sysfs entries', committed on January 31.

Thanks for looking at this.

  Tom
