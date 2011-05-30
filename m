Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1E3AZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 20:25:28 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34255 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117Ab1E3AZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 20:25:27 -0400
X-Sasl-enc: /rmx1QDtZ5T2gbCUwGyyU50RjAHC7IACOmIeeOHUH6bu 1306715125
Date: Mon, 30 May 2011 08:01:14 +0800
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <gregkh@suse.de>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [57/71] block: rescan partitions on invalidated devices
 on -ENOMEDIA too
Message-ID: <20110530000114.GA5135@kroah.com>
References: <20110519180626.GA16555@kroah.com>
 <20110519180559.722522150@clark.kroah.org>
 <BANLkTi=dKXo=TeTU7a--r3YCxrptNU3VVg@mail.gmail.com>
 <20110519181814.GA17816@suse.de>
 <20110525090927.GD10146@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525090927.GD10146@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 11:09:27AM +0200, Tejun Heo wrote:
> Hello, Greg.
> 
> On Thu, May 19, 2011 at 11:18:14AM -0700, Greg KH wrote:
> > On Thu, May 19, 2011 at 08:12:44PM +0200, Tejun Heo wrote:
> > > Can you please hold this for a while?  It causes an extra warning
> > > message to be printed during device detection.  It isn't harmful but
> > > still.  I'll soon send a patch to resolve the issue and it would be
> > > better for them to go together.
> > 
> > Sure, I've dropped this one for now.  Let me know when I should add it
> > back to the next round of stable releases.
> 
> ff2a9941ca (block: move bd_set_size() above rescan_partitions() in
> __blkdev_get()) which fixes the warning is now in mainline.  Please
> apply this and ff2a9941ca to the next -stable.  I also noted it in the
> commit message of ff2a9941ca.

Now done, thanks for letting me know.

greg k-h
