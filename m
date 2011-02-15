Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab1BOR05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:26:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:50313 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab1BOR0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:26:55 -0500
Date: Tue, 15 Feb 2011 09:22:53 -0800
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hashir Abdi <habdi@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>
Subject: Re: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
Message-ID: <20110215172253.GB18437@suse.de>
References: <1297782937-24082-1-git-send-email-kys@microsoft.com>
 <20110215155954.GA32313@suse.de>
 <FB42D5CCD7B5934EB1827DB5ED9B850E07085DA1@TK5EX14MBXC104.redmond.corp.microsoft.com>
 <8AFC7968D54FB448A30D8F38F259C56233F9714A@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56233F9714A@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 04:59:28PM +0000, Hank Janssen wrote:
> 
> 
> > -----Original Message-----
> > From: KY Srinivasan
> > Sent: Tuesday, February 15, 2011 8:54 AM
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@suse.de]
> > > Sent: Tuesday, February 15, 2011 11:00 AM
> > > To: KY Srinivasan
> > > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > > virtualization@lists.osdl.org; Haiyang Zhang; Hank Janssen
> > > Subject: Re: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
> > >
> 
> > > And why are you still printing this out for the whole world to see?
> > Greg, this patch addressed a specific comment with regards dynamically
> > allocate the irq.
> > Hank is working on a patch to address the various DPRINTS in the code.
> 
> Before the end of the week I will submit two patches for this;
> 
> 	Remove DPRINT and change it to printk

No, use dev_dbg() and friends instead of "raw" printk() calls.

> 	Remove excessive printouts on startup of vmbus

That would be nice to see.  There should be almost nothing outputed by
these drivers on "normal" operation.

thanks,

greg k-h
