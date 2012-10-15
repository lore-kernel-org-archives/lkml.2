Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2JOQsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:48:14 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:65526 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2JOQsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:48:13 -0400
Date: Mon, 15 Oct 2012 09:48:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 3/3] USB: forbid memory allocation with I/O during
 bus reset if storage interface exits
Message-ID: <20121015164801.GA6458@kroah.com>
References: <1350278059-14904-1-git-send-email-ming.lei@canonical.com>
 <2564763.3cNFlv543H@linux-lqwf.site>
 <CACVXFVPi=fq1NP-nuWQi34xTpGgWbaceW1Hbzcq38RqQMF_T-w@mail.gmail.com>
 <1921559.OPsFBnvatA@linux-lqwf.site>
 <CACVXFVM9bSX+iMx_7Z+S=HsNqNTpR0=qU3MeDQ1wD1LLM0UK-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVM9bSX+iMx_7Z+S=HsNqNTpR0=qU3MeDQ1wD1LLM0UK-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 09:21:13PM +0800, Ming Lei wrote:
> On Mon, Oct 15, 2012 at 8:30 PM, Oliver Neukum <oneukum@suse.de> wrote:
> 
> >
> > All network devices?
> 
> Good point, but I am wondering if there are guys who would like to
> bring up iSCSI over usb network dongle, which should be
> very slow at least with high speed.  For super speed device,
> looks there are few network dongles in market now.
> 
> So how about keeping the limit now?
> 
> We can remove the limit or extend it to network device if there are
> some USB 3.0 network dongles coming.

No, don't limit us for no good reason, that's not acceptable at all.
Patching old kernels when new devices show up that work on those old
kernels (like USB network devices that follow the spec with no driver
change needed), is not a good idea.

So I agree with Oliver here, this isn't acceptable.

greg k-h
