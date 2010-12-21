Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab0LUR77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:59:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab0LUR75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:59:57 -0500
Date: Tue, 21 Dec 2010 09:59:42 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>, Anoop P <anoop.pa@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, dbrownell@users.sourceforge.net,
        sarah.a.sharp@linux.intel.com, andiry.xu@amd.com, agust@denx.de,
        ddaney@caviumnetworks.com, gadiyar@ti.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] EHCI support for on-chip PMC MSP USB controller.
Message-ID: <20101221175942.GB8709@suse.de>
References: <1292929580-5829-1-git-send-email-anoop.pa@gmail.com>
 <Pine.LNX.4.44L0.1012211050470.31667-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1012211050470.31667-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 11:00:02AM -0500, Alan Stern wrote:
> On Tue, 21 Dec 2010, Anoop P wrote:
> 
> > From: Anoop P A <anoop.pa@gmail.com>
> > 
> > This patch includes.
> > 
> > 1. USB host driver for MSP71xx family SoC on-chip USB controller.
> > 2. Platform support for USB controller.
> 
> It also contains changes to the core USB hub driver code.  You should 
> mention things like that in the patch description.

And that portion of the code should be split into a different patch to
make it easier to review.

thanks,

greg k-h
