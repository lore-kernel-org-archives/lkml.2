Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab1DUFFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 01:05:50 -0400
Received: from kroah.org ([198.145.64.141]:49751 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1DUFFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 01:05:49 -0400
Date: Wed, 20 Apr 2011 22:05:44 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.jf.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] gma500: add the ability to request backed space or
 not
Message-ID: <20110421050544.GA5832@kroah.com>
References: <20110419142432.16479.89255.stgit@localhost.localdomain>
 <20110419142658.16479.59689.stgit@localhost.localdomain>
 <20110420203117.GA14141@kroah.com>
 <20110420222108.38bc8587@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420222108.38bc8587@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 10:21:08PM +0100, Alan Cox wrote:
> On Wed, 20 Apr 2011 13:31:17 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Tue, Apr 19, 2011 at 03:27:10PM +0100, Alan Cox wrote:
> > > We will will need this for doing a GEM allocator. It should also avoid any
> > > crashes with the current code if the stolen area is too small.
> > > 
> > > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > 
> > What tree did you make this against?
> 
> Against -next and the previous patches I sent you. Have you been
> stripping white space automatically again. That will break follow up
> patches if so.

No, I have not stripped any more whitespace since the first problems
that this caused on the driver.

thanks,

greg k-h
