Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab2AUM45 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 07:56:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab2AUM4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 07:56:43 -0500
Date: Sat, 21 Jan 2012 07:53:14 -0500
From: Greg KH <gregkh@suse.de>
To: Kashyap Gada <gada.kashyap@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        bringert@android.com, linux-kernel@vger.kernel.org, arve@android.com,
        john.stultz@linaro.org, ccross@android.com
Subject: Re: [PATCH 4/4] Staging: android: Fix struct definitioni warning
 from static to const
Message-ID: <20120121125314.GC18829@suse.de>
References: <1327112269-17530-1-git-send-email-gada.kashyap@gmail.com>
 <20120121080838.GK3294@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120121080838.GK3294@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 11:08:38AM +0300, Dan Carpenter wrote:
> On Sat, Jan 21, 2012 at 02:17:49AM +0000, Kashyap Gada wrote:
> > ---
> >  drivers/staging/android/ashmem.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
> > index 4a00174a5..9f1f27e 100644
> > --- a/drivers/staging/android/ashmem.c
> > +++ b/drivers/staging/android/ashmem.c
> > @@ -680,7 +680,7 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >  	return ret;
> >  }
> >  
> > -const struct file_operations ashmem_fops = {
> > +static const struct file_operations ashmem_fops = {
> >  	.owner = THIS_MODULE,
> >  	.open = ashmem_open,
> >  	.release = ashmem_release,
> 
> No.  We're not going to merge the broken patch which removes the
> static.
> 
> Plus your patch numbering is totally bogus.
> [PATCH 2/2]
> [PATCH 3/3]
> [PATCH 4/4]
> [PATCH 5/5]
> 
> The second number is supposed to say how many patches there are in
> the series.  If these were bug fixes, we'd go out of our way to work
> with you, but you're just sending random whitespace fixes so they
> have to be pretty much perfect.  (In other words, please slow down
> and work more carefully or else focus on fixing bugs instead of
> whitespace).

The patches also don't have the most basic things needed for acceptance
(i.e. a description and most importantly, a Signed-off-by:), so I can't
take them at all.

greg k-h
