Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab1DZAPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:15:38 -0400
Received: from kroah.org ([198.145.64.141]:45070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233Ab1DZAPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:15:37 -0400
Date: Mon, 25 Apr 2011 17:15:12 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.jf.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] gma500: add the ability to request backed space or
 not
Message-ID: <20110426001512.GA15932@kroah.com>
References: <20110419142432.16479.89255.stgit@localhost.localdomain>
 <20110419142658.16479.59689.stgit@localhost.localdomain>
 <20110420203117.GA14141@kroah.com>
 <20110420222108.38bc8587@lxorguk.ukuu.org.uk>
 <20110421050649.GA6151@kroah.com>
 <20110421094909.4ea354de@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421094909.4ea354de@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 09:49:09AM +0100, Alan Cox wrote:
> > > Against -next and the previous patches I sent you. Have you been
> > > stripping white space automatically again. That will break follow up
> > > patches if so.
> > 
> > Ok, I'm stupid, I missed that you sent me patches already for this
> 
> ITYAM "my superhero powers seem to have faded slightly today"
> 
> > driver, and didn't apply them first.  Sorry about that, I'll try it
> > again tomorrow when I have more sleep...
> 
> Ok cool - that would explain it.

Yes, it worked when I applied the first round of patches first, they
should now all be queued up.

sorry for the noise,

greg k-h
