Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031512Ab2COVJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:09:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39134 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030580Ab2COVI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:08:59 -0400
Date: Thu, 15 Mar 2012 14:08:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Miller <amiller@amilx.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Staging: rtl8187se: r8180_dm.c: Fix comments
Message-ID: <20120315210856.GA18911@kroah.com>
References: <1331838321-18453-1-git-send-email-amiller@amilx.com>
 <1331838321-18453-6-git-send-email-amiller@amilx.com>
 <20120315193405.GE3163@mwanda>
 <20120315204923.GA14240@iron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315204923.GA14240@iron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 04:49:23PM -0400, Andrew Miller wrote:
> On Thu, Mar 15, 2012 at 10:34:05PM +0300, Dan Carpenter wrote:
> > On Thu, Mar 15, 2012 at 03:05:21PM -0400, Andrew Miller wrote:
> > > -//+by amy 080312
> > > +/*{by amy 080312 */
> >       ^^^^^^^^^^^^^
> > Just remove these comments.  We use version control to see who is
> > doing what.
> > 
> > >  
> > > -	//printk("----> DoTxHighPower()\n");
> > > +	/* printk("----> DoTxHighPower()\n"); */
> > >  
> > 
> > Also this dead debugging code can be deleted.  There was a bunch of
> > it.
> > 
> > regards,
> > dan carpenter
> 
> Thanks for the advice, If the patch goes through. I'll make another one 
> with this changes. If not then I will include them when I revise it.

Send another one on top of this one that removes those unneeded
comments, as I've just applied all of the patches in this series.

thanks,

greg k-h
