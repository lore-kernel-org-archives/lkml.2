Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0IBD0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:26:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:57967 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab0IBD0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:26:30 -0400
Date: Wed, 1 Sep 2010 20:22:27 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Greg KH <greg@kroah.com>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>, yong.y.wang@intel.com,
        qi.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, alan@linux.intel.com, margie.foster@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Message-ID: <20100902032227.GA27463@suse.de>
References: <4C7E441E.4090006@dsn.okisemi.com> <20100902010236.GA21782@kroah.com> <000601cb4a47$b1a7d1d0$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000601cb4a47$b1a7d1d0$66f8800a@maildom.okisemi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 11:36:45AM +0900, Masayuki Ohtake wrote:
> Hi Greg,
> 
> > Nope, I still get a warning with this patch, but I'll go fix it up:
> Sorry for our warning.
> We tested with kernel-2.6.35.3.
> We will modify so that warning becomes to disappear soon.

I already fixed this up now.  The issue was that you were not using %p
to print out a pointer and you were trying to use an int instead of a
ssize_t for the pci rom stuff.  All of that shows up when building on
x86-64.

I've commited the fix to my tree, you should have been copied on it
already.

thanks,

greg k-h
