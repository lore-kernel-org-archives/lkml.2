Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1HWAot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:44:49 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53615 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957Ab1HWAop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:44:45 -0400
X-Sasl-enc: MRFHZZ/cOlwlFCg6kL13qxa2Lbh/cYJEjhBmeUz3SEg8 1314060284
Date: Mon, 22 Aug 2011 17:33:52 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Sysfs group create for empty groups.
Message-ID: <20110823003352.GA5982@kroah.com>
References: <1313576222-27743-1-git-send-email-jic23@cam.ac.uk>
 <4E4BEBFD.3040004@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4BEBFD.3040004@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 05:27:41PM +0100, Jonathan Cameron wrote:
> On 08/17/11 11:17, Jonathan Cameron wrote:
> > The following is a quick stab at avoiding a hideous work around
> > we are currently using in IIO.  In some cases we have entire
> > attribute groups that are created from descriptions an array
> > of struct iio_chan_spec.  To keep the reference counts sane
> > and cause subdirectories to be created we are currently using
> > dummy groups and dummy attribute arrays (provided once in the
> > core).  This series is an initial probably stupid approach
> > to avoiding this.
> > 
> > Greg has expressed some doubts about whether subdirectories are
> > ever a good idea, but the problem occurs for the top level
> > directory as well (handled by patch 1).
> > 
> > Note, all attributes are created at probe time.  Ultimately we
> > are just respinning the create_group code to allow us to create
> > the attributes from a device description rather than statically
> > allocating them in each driver (results in a massive reduction
> > in repeated code).
> > 
> > All opinions welcomed.
> > 
> > (this is definitely an rfc, the code isn't even tested yet)
> Now tested and looks fine, so I've pushed it to our iio dev tree
> (which is re based a few times a day currently so I can always
> drop it again ;)

Can you show me how you would use this so I could try to understand it a
bit better?

confused,

greg k-h
