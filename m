Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1C2NUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:20:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab1C2NUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:20:41 -0400
Date: Tue, 29 Mar 2011 06:14:53 -0700
From: Greg KH <gregkh@suse.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        rmk+kernel@arm.linux.org.uk, linux-wireless@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH 0/1] new module for amba axi on-chip interconnect
Message-ID: <20110329131453.GA17302@suse.de>
References: <1301391619-4499-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301391619-4499-1-git-send-email-arend@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 11:40:18AM +0200, Arend van Spriel wrote:
> GUIDANCE NEEDED:
> This patch puts the module at proposed location. Please provide your
> guidance if there is a better location within the linux tree for this
> module.
> 
> This module has been isolated from the brcm80211 driver currently
> located in staging and provided to other drivers for chipsets using
> the AMBA AXI on-chip interconnect with ARM Device Management Plugin
> (DMP) silicon IP, which provides system discovery (chip being the
> system) and basic core function (disable, reset, etc.).
> 
> The module has previously been posted on the linux-wireless list and
> comments by Randy Dunlap have been taken in. Also the SubmitChecklist
> has been followed.
> 
> Arend van Spriel (1):
>   drivers: brcmaxi: provide amba axi functionality in separate module
> 
>  drivers/Kconfig            |    2 +
>  drivers/Makefile           |    1 +
>  drivers/brcmaxi/Kconfig    |   23 ++

I thought this was going under drivers/staging/  What changed your mind?
What other drivers are going to use this, I thought the current broadcom
drivers in drivers/net/wireless were not going to need this.

thanks,

greg k-h
