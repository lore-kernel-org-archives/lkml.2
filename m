Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1CBO2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:28:23 -0500
Received: from kroah.org ([198.145.64.141]:35988 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1CBO2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:28:19 -0500
Date: Wed, 2 Mar 2011 09:26:26 -0500
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arend van Spriel <arend@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>
Subject: Re: linux-next: manual merge of the staging tree with the wireless
 tree
Message-ID: <20110302142626.GC2889@kroah.com>
References: <20110302172754.412dca34.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302172754.412dca34.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 05:27:54PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/brcm80211/brcmsmac/wl_mac80211.c between commit
> 7bb4568372856688bc070917265bce0b88bb7d4d ("mac80211: make tx() operation
> return void") from the wireless tree (where this file is called
> drivers/staging/brcm80211/sys/wl_mac80211.c) and commits
> 62b54dca17ef40116491b0ca27ca35fbe9daedc6 ("staging: brcm80211: cleanup
> function prototypes in header files") and
> 55182a10063c40eda4dc5afecff712e5c3617ffc ("staging: brcm80211: cosmetic
> changes") from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks, that looks good to me.

greg k-h
