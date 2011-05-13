Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab1EMXZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 19:25:31 -0400
Received: from kroah.org ([198.145.64.141]:42904 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758831Ab1EMXZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 19:25:26 -0400
Date: Fri, 13 May 2011 16:12:00 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Vozeler <max@hinterhof.net>, matt mooney <mfm@muteddisk.com>
Subject: Re: linux-next: manual merge of the staging tree with Linus' tree
Message-ID: <20110513231200.GA27663@kroah.com>
References: <20110513140821.bfef61a3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513140821.bfef61a3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 02:08:21PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/usbip/vhci_sysfs.c between commit d1b2e95ab016 ("staging:
> usbip: vhci: fix oops on subsequent attach") from Linus' tree and commit
> 7aaacb43ed97 ("staging: usbip: fix header includes") from the staging
> tree.
> 
> The latter superceded the former for the conflict in the includes.

Ah, missed that, thanks, I'll merge these together soon and resolve
them.

greg k-h
