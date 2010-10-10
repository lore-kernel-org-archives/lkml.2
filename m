Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0JKDW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 23:22:26 -0400
Received: from kroah.org ([198.145.64.141]:60500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab0JKDWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 23:22:25 -0400
Date: Sun, 10 Oct 2010 13:29:06 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>
Subject: Re: linux-next: Tree for October 8 (staging/brcm80211)
Message-ID: <20101010202906.GA4900@kroah.com>
References: <20101008161552.07c9f137.sfr@canb.auug.org.au> <20101010115832.0bf5dff8.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010115832.0bf5dff8.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 11:58:32AM -0700, Randy Dunlap wrote:
> On Fri, 8 Oct 2010 16:15:52 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20101007:
> 
> 
> 
> drivers/staging/brcm80211/brcmfmac/dhd_linux.c:432: note: expected 'void *' but argument is of type 'sk_buff_data_t'
> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:1337: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

This is x86-64, right?

> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:2120: warning: initialization from incompatible pointer type
> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:2121: warning: initialization from incompatible pointer type
> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:2122: warning: initialization from incompatible pointer type
> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:4035: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'
> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:4048: warning: format '%d' expects type 'int', but argument 2 has type 'size_t'

I'll work on these.

thanks,

greg k-h
