Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab1CSAvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 20:51:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:43056 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932774Ab1CSAva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 20:51:30 -0400
Date: Fri, 18 Mar 2011 17:22:46 -0700
From: Greg KH <gregkh@suse.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org,
        jacek.danecki@intel.com, ed.ciechanowski@intel.com,
        linux-kernel@vger.kernel.org, dmilburn@redhat.com,
        edmund.nadolski@intel.com, Jeff Garzik <jeff@garzik.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] firmware/efi: export a routine to retrieve efi-variables
 by GUID
Message-ID: <20110319002246.GB14249@suse.de>
References: <20110318221606.26841.92271.stgit@localhost6.localdomain6>
 <20110318225016.GB15921@suse.de>
 <AANLkTim+HB0GWzGiif=MvYHaiXMSLuVB6R0=UK3906xU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim+HB0GWzGiif=MvYHaiXMSLuVB6R0=UK3906xU@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 04:10:10PM -0700, Dan Williams wrote:
> > I needed all patches in linux-next _before_ the merge window opened to
> > be able to accept it.
> 
> Yes, I know, and as dmaengine maintainer I also hate being ambushed by
> last minute patches, but now I am unfortunately one of those annoying
> people on the other side of the coin.

Then you should know better than to try to go around the well-known
rules :)

> The review has been intermittent until very recently.  Given that
> fact, James was understandably not ready to take it into
> drivers/scsi/.  So the thought was to leave time for the review to pan
> out and then attempt a post -rc1 merge through scsi or staging.

There are no "post -rc1" merges for staging, it follows the same rules
as the rest of the kernel.  Which means that you will have to wait for
.40 before it can be merged, sorry.

> > So, sorry, it will have to wait until .40.
> > Please send me the isci driver and I will be glad to queue it up for
> > staging for that kernel.
> 
> We will submit a revised driver in the next few weeks.

Fine, I'll queue it up for .40 then.

greg k-h
