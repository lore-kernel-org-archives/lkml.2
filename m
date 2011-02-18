Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab1BRREp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 12:04:45 -0500
Received: from cantor.suse.de ([195.135.220.2]:48715 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab1BRREk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 12:04:40 -0500
Date: Fri, 18 Feb 2011 09:05:38 -0800
From: Greg KH <gregkh@suse.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        davinci-linux-open-source@linux.davincidsp.com, amit.chatterjee@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] PRUSS UIO driver support
Message-ID: <20110218170538.GB11773@suse.de>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com>
 <1298041530-26855-2-git-send-email-pratheesh@ti.com>
 <20110218163147.GD4684@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218163147.GD4684@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 05:31:47PM +0100, Hans J. Koch wrote:
> On Fri, Feb 18, 2011 at 08:35:29PM +0530, Pratheesh Gangadhar wrote:
> > Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>

As noted by others, this needs to go at the end of the changelog
comment.

Also, always run your patches through the scripts/checkpatch.pl script
and fix the warnings and errors it finds.  To not do so is just rude as
you are asking us to do the basic review work that you yourself did not
do in the first place.

> > +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> > +{
> > +	return IRQ_HANDLED;
> > +}
> 
> ROTFL. That reminds me of an old story. The last time I wrote this, and
> Greg dared to post it, we received this reply:
> 
> http://marc.info/?l=linux-kernel&m=116604101232144&w=2
> 
> So, if you really have a _very_ good reason why this _always_ works on
> _any_ DA850 board, add a comment that explains why. Otherwise the whole
> patch set will be doomed.

Nope, this whole patch set is doomed if this isn't fixed, I'm not going
to accept it no matter how much you want to try to say this is ok on
this hardware.

thanks,

greg k-h
