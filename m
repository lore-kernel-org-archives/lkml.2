Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab0EQSUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:20:23 -0400
Received: from kroah.org ([198.145.64.141]:34164 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab0EQSUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:20:21 -0400
Date: Mon, 17 May 2010 11:01:00 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Youn <John.Youn@synopsys.com>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the usb tree
Message-ID: <20100517180100.GA16419@kroah.com>
References: <20100517161603.f83a98d8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517161603.f83a98d8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 04:16:03PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the usb tree, today's linux-next build (powerpc allyesconfig)
> produced this warning:
> 
> drivers/usb/host/xhci-ring.c: In function 'prepare_ring':
> drivers/usb/host/xhci-ring.c:1729: warning: unused variable 'addr'
> 
> Introduced by commit a2fbb0e4784f6d1b3be0779918e84dd3c0c73f04 ("USB:
> xhci: Transfer ring link TRB activation change").

Thanks, I'll go fix this up.

greg k-h
