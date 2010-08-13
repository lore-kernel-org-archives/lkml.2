Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934499Ab0HMO60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 10:58:26 -0400
Received: from kroah.org ([198.145.64.141]:49251 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934371Ab0HMO6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 10:58:23 -0400
Date: Fri, 13 Aug 2010 07:49:29 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: linux-next: build warning after merge of the final tree (usb
 tree related)
Message-ID: <20100813144929.GA25259@kroah.com>
References: <20100802141823.143b2a36.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802141823.143b2a36.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 02:18:23PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) produced these warnings:
> 
> /scratch/sfr/next/drivers/usb/gadget/storage_common.c:718: warning: 'fsg_show_nofua' defined but not used
> /scratch/sfr/next/drivers/usb/gadget/storage_common.c:782: warning: 'fsg_store_nofua' defined but not used
> /scratch/sfr/next/drivers/usb/gadget/storage_common.c:718: warning: 'fsg_show_nofua' defined but not used
> /scratch/sfr/next/drivers/usb/gadget/storage_common.c:782: warning: 'fsg_store_nofua' defined but not used
> 
> Introduced by commit ed4825f7332669779540be27cb263daf22af3b1c ("USB:
> gadget: storage: optional SCSI WRITE FUA bit") from the usb tree.

Sorry about missing this, I have a patch to fix this up now.

greg k-h
