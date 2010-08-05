Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab0HEPwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:52:06 -0400
Received: from kroah.org ([198.145.64.141]:46554 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab0HEPwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:52:03 -0400
Date: Thu, 5 Aug 2010 08:51:26 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: linux-next: manual merge of the tty tree with the kgdb tree
Message-ID: <20100805155126.GB11121@kroah.com>
References: <20100805131700.5c03444c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805131700.5c03444c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 01:17:00PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the tty tree got a conflict in
> drivers/char/vt.c between commit be6f9f80724e1684987c486c33c4eb882ba50680
> ("vt,console,kdb: automatically set kdb LINES variable") from the kgdb
> tree and commit 46ca223803ae544fb5460bc81d961244866fcdc4 ("vt: clean up
> the code - use kernel library") from the tty tree.
> 
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.

Thanks, that's an easy fixup.

greg k-h
