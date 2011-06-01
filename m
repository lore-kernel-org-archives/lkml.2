Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab1FAWmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:42:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:33968 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428Ab1FAWmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:42:08 -0400
X-ExtLoop1: 1
Date: Wed, 1 Jun 2011 15:42:05 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH 2/2] xhci: Do not issue device reset when device
 is not setup
Message-ID: <20110601224205.GC13079@xanatos>
References: <1306963670-6344-1-git-send-email-m.b.lankhorst@gmail.com>
 <1306963670-6344-2-git-send-email-m.b.lankhorst@gmail.com>
 <20110601221722.GB17429@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601221722.GB17429@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten, if you feel a patch needs to be added to the stable trees,
please just add this line below your Signed-off-by line:

Cc: stable@kernel.org

Don't Cc stable in your initial RFC patches.  Once they're done, I'll
queue them to my xHCI tree and send them off to Greg.  When Greg sends
them off to Linus for inclusion into 3.0, the patches will automatically
get picked up into the stable tree.

Sarah Sharp

On Thu, Jun 02, 2011 at 07:17:22AM +0900, Greg KH wrote:
> On Wed, Jun 01, 2011 at 11:27:50PM +0200, Maarten Lankhorst wrote:
> > Xhci controllers respond to this by returning an error. Instead of
> > issuing a command that will fail, just return.
> > 
> > This fixes the xhci driver not working on asrock P67 Pro/Extreme boards.
> > 
> > Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> > ---
> >  drivers/usb/host/xhci.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> </formletter>
