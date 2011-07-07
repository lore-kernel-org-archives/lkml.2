Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1GGNof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:44:35 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60252 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756332Ab1GGNoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:44:30 -0400
X-Sasl-enc: K01DfJcFLwMPM0DBfhnFdwk8Q83//rmPYJSA5XaAHUSp 1310046269
Date: Thu, 7 Jul 2011 06:43:04 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaliy Ivanov <vitalivanov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>
Subject: Re: linux-next: manual merge of the staging tree with the net and
 trivial trees
Message-ID: <20110707134304.GB26939@kroah.com>
References: <20110707153840.c70fde0f5881bbe0c82eb6dc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707153840.c70fde0f5881bbe0c82eb6dc@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 03:38:40PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/bcm/headers.h
> drivers/staging/brcm80211/brcmfmac/dhd_linux.c
> drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h between commits
> 219eb47e6f35 ("net/staging: add needed interrupt.h and hardirq.h
> includes") from the net tree and e44ba033c565 ("treewide: remove
> duplicate includes") from the trivial tree and various commits from the
> staging tree.
> 
> I fixed thme up (see below) and can carry the fixes as necessary.

Looks correct, thanks.

greg k-h
