Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab0INEOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:14:52 -0400
Received: from kroah.org ([198.145.64.141]:58513 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0INEO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:14:26 -0400
Date: Mon, 13 Sep 2010 21:08:03 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mihai Don??u <mihai.dontu@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20100914040803.GB11972@kroah.com>
References: <20100914125431.1603ffd1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914125431.1603ffd1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 12:54:31PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> In file included from drivers/usb/gadget/ether.c:123:
> drivers/usb/gadget/rndis.c: In function 'rndis_init':
> drivers/usb/gadget/rndis.c:1163: error: expected ';' before 'if'
> 
> Caused by commit c8feb3bad134f927a624cc19da13f57627b905e2 ("USB: gadget:
> rndis: fix up coding style issues in the file").
> 
> I used the version of the usb tree from next-20100913 for today.

I can't duplicate this at all, are you sure it's coming from my tree?
What is your .config here?

confused,

greg k-h
