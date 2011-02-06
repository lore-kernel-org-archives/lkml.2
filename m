Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1BFUhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:37:08 -0500
Received: from void.printf.net ([89.145.121.20]:56177 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab1BFUhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:37:06 -0500
Date: Sun, 6 Feb 2011 20:37:05 +0000
From: Chris Ball <cjb@laptop.org>
To: Pierre Tardy <pierre.tardy@intel.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] introduce mmc per device quirks
Message-ID: <20110206203705.GC23366@void.printf.net>
References: <cover.1297014807.git.pierre.tardy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1297014807.git.pierre.tardy@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 07:03:45PM +0100, Pierre Tardy wrote:
> This patchset is the resend and cleanup of
> the mmc per device quirks patchset.
> 
> User of the quirks is attached, which allows
> clock gating framework to be used for specific sdio
> card that are known to work.
> 
> Pierre Tardy (3):
>   mmc: add per device quirk placeholder
>   mmc: add MMC_QUIRK_BROKEN_CLK_GATING
>   mmc: remove BROCKEN_CLK_GATING quirk for wl1271

Looks good, pushed to mmc-next, thanks!

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
