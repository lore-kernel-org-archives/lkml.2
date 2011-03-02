Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab1CBVJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:09:56 -0500
Received: from kroah.org ([198.145.64.141]:54656 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab1CBVJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:09:54 -0500
Date: Wed, 2 Mar 2011 16:05:11 -0500
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] staging/brcm80211: fix printk format warnings
Message-ID: <20110302210511.GA20798@kroah.com>
References: <20110301181119.f1c7a9c3.sfr@canb.auug.org.au>
 <20110301162948.34c28d6e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301162948.34c28d6e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 04:29:48PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:1379: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
> drivers/staging/brcm80211/sys/wl_mac80211.c:1827: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
> drivers/staging/brcm80211/sys/wl_mac80211.c:1832: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Acked-by: Roland Vossen <rvossen@broadcom.com>
> ---
>  drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    2 +-
>  drivers/staging/brcm80211/sys/wl_mac80211.c      |    4 ++--

This file doesn't apply to my tree at all.

confused,

greg k-h
