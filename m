Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032178Ab2COR4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:56:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:32111 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032166Ab2COR4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:56:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119425022"
Date: Thu, 15 Mar 2012 10:56:08 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alex Shi <alex.shi@intel.com>
Cc: gregkh <gregkh@linuxfoundation.org>,
        "Sharp, Sarah A" <sarah.a.sharp@intel.com>,
        Alan stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
Message-ID: <20120315175608.GA6077@xanatos>
References: <1331787186.2979.71.camel@debian>
 <20120315145743.GA7928@kroah.com>
 <4F6204B7.5010908@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6204B7.5010908@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 11:03:19PM +0800, Alex Shi wrote:
> On 03/15/2012 10:57 PM, gregkh wrote:
> 
> > On Thu, Mar 15, 2012 at 12:53:06PM +0800, Alex Shi wrote:
> >>
> >> According to Felipe and Alan's comments the second parameter of irq
> >> handler should be 'void *' not a specific structure pointer. 
> >> So change it.
> >>
> >> Signed-off-by: Alex Shi <alex.shi@intel.com>
> >> ---
> >>  drivers/usb/host/xhci-ring.c |    2 +-
> >>  drivers/usb/host/xhci.c      |    4 ++--
> >>  drivers/usb/host/xhci.h      |    2 +-
> >>  3 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > Is this needed in my -next tree now?  Or is it something for later?
> 
> 
> Appreciate if it can be in -next tree. :)
> 
> > 
> > Any reason you did not put Sarah on the To: line here?  She's the one
> > that needs to ack it before I can accept it.
> 
> 
> Sarah, would you like to give some comments here?

Looks fine.  I'll send a pull request to Greg with this patch after I
verify it doesn't generate new warnings.

Sarah Sharp
