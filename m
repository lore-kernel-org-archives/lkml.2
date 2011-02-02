Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1BBWCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:02:19 -0500
Received: from kroah.org ([198.145.64.141]:34990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab1BBWCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:02:11 -0500
Date: Wed, 2 Feb 2011 13:58:41 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>
Subject: Re: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-ID: <20110202215841.GB28849@kroah.com>
References: <20110131160926.27223d25.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131160926.27223d25.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 04:09:26PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/brcm80211/brcmsmac/wl_mac80211.c,
> drivers/staging/brcm80211/sys/wlc_mac80211.c and
> drivers/staging/brcm80211/sys/wlc_mac80211.c (these three files names are
> the same file, it has been renamed twice, I think ..) between
> commit4032ec639af9b735fdd903fab09de567bd73eaa0 ("staging: brcm80211: fix
> suspend/resume issue in brcmsmac") from the staging.current tree and
> commit c836f77fdba3631e295e3da1718ab53a9038fdf2 ("staging: brcm80211: use
> KBUILD_MODNAME as driver name in registration") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

I've merged with Linus's tree now, so this should not be needed anymore.

thanks,

greg k-h
