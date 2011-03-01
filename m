Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab1CAFmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:42:44 -0500
Received: from kroah.org ([198.145.64.141]:43471 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab1CAFmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:42:37 -0500
Date: Mon, 28 Feb 2011 18:03:02 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: gma500: Rip out the memory manager
Message-ID: <20110301020302.GA11353@kroah.com>
References: <20110224162440.27093.80825.stgit@localhost.localdomain>
 <20110224162457.27093.32399.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224162457.27093.32399.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 04:25:09PM +0000, Alan Cox wrote:
> At this point we simply stuff the display at the start of the stolen memory
> area that the BIOS gave us. No user framebuffers no multiple framebuffers.
> 
> However from here we have a better chance of seeing what is going on and
> writing an actual gem manager for the driver.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

This doesn't apply.

The 1/2 patch had some fuzz in the Makefile, which I fixed up by hand,
but it makes me think that you are diffing this against some different
tree.

Care to redo it and resend?

thanks,

greg k-h
