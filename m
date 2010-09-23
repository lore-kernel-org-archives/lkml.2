Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab0IWOPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:15:47 -0400
Received: from kroah.org ([198.145.64.141]:48019 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773Ab0IWOPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:15:46 -0400
Date: Thu, 23 Sep 2010 07:14:33 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Alan Cox <alan@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20100923141433.GC31738@kroah.com>
References: <20100923142018.55019d59.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923142018.55019d59.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 02:20:18PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the tty tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/char/ip2/ip2main.c:459: error: 'ip2_get_icount' undeclared here (not in a function)
> 
> Caused by commit 157be28e51ed476aa357c8718aaef4832f4da66b ("tty: icount
> changeover for other main devices").
> 
> Please build test (especially the trivial "cut and paste" changes) ...
> 
> I have reverted that commit for today.

Ick, sorry about that.  Alan, care to send a fixup patch for this?

thanks,

greg k-h
