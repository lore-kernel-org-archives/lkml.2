Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1ERFuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:50:05 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52195 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592Ab1ERFuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:50:04 -0400
X-Sasl-enc: fanZj1205RqUJo8fOcScHum7cSFzKjiSAYklmntAk8wJ 1305697802
Date: Tue, 17 May 2011 22:09:13 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jouni Malinen <jouni.malinen@atheros.com>,
        Sukesh Srikakula <sukeshs@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>
Subject: Re: linux-next: manual merge of the staging tree with the wireless
 tree
Message-ID: <20110518050913.GA25333@kroah.com>
References: <20110518125633.0164cb32.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518125633.0164cb32.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 12:56:33PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c between commit
> 5a083c0aba95 ("cfg80211: Use consistent BSS matching between scan and
> sme") from the wireless tree and commit e494632efcd9 ("staging:
> brcm80211: Fixed bss (re)connect/disconnect issues in brcmfmac driver")
> from the staging tree.
> 
> I fixed it up (see below) anc can carry the fix as necessary.

Looks great to me, thanks for doing this.

greg k-h
