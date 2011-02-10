Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab1BJRl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:41:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab1BJRl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:41:27 -0500
Date: Thu, 10 Feb 2011 09:42:19 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] kobject.h: fix build when CONFIG_HOTPLUG is
 disabled
Message-ID: <20110210174219.GA23761@suse.de>
References: <20110207161902.a4c36e08.sfr@canb.auug.org.au>
 <20110206215718.185b6262.randy.dunlap@oracle.com>
 <20110210093847.995e6f97.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210093847.995e6f97.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 09:38:47AM -0800, Randy Dunlap wrote:
> On Sun, 6 Feb 2011 21:57:18 -0800 Randy Dunlap wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > When CONFIG_HOTPLUG is not enabled, the inline function add_uevent_var()
> > needs to have its __attribute__ before the function name/parameters,
> > otherwise there are syntax errors.
> > 
> > linux-next-20110207/include/linux/kobject.h:232: error: expected ',' or ';' before '{' token
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Greg,
> This patch is still needed in linux-next, please...

Sorry, yes, it's in my queue, I'm still getting over the flu, give me a
day or so please.

greg k-h
