Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab0D3SCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:02:32 -0400
Received: from kroah.org ([198.145.64.141]:51961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933361Ab0D3Rnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:43:32 -0400
Date: Fri, 30 Apr 2010 07:41:28 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: linux-next: build failure after merge of the staging-next tree
Message-ID: <20100430144128.GC1824@kroah.com>
References: <20100430155224.ab570260.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430155224.ab570260.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 03:52:24PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/media/video/tlg2300/pd-main.c: In function 'poseidon_probe':
> drivers/media/video/tlg2300/pd-main.c:457: error: 'struct usb_device' has no member named 'autosuspend_disabled'
> drivers/net/wimax/i2400m/usb.c: In function 'i2400mu_probe':
> drivers/net/wimax/i2400m/usb.c:508: error: 'struct usb_device' has no member named 'autosuspend_disabled'
> 
> Caused by commit 3a03bb2443e8fb3b35666dc598e7f626519c544a ("USB: use PM
> core routines to enable/disable autosuspend") from the usb tree.  I have
> reverted that commit for today.

It would be good to get that back into the tree.  Alan, care to fix this
up?

thanks,

greg k-h
