Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1BFUfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:35:37 -0500
Received: from void.printf.net ([89.145.121.20]:56165 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab1BFUf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:35:27 -0500
Date: Sun, 6 Feb 2011 20:35:20 +0000
From: Chris Ball <cjb@laptop.org>
To: Pierre Tardy <pierre.tardy@intel.com>
Cc: linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] sdhci runtime_pm implementation using mmc clock
	gating fw
Message-ID: <20110206203520.GB23366@void.printf.net>
References: <cover.1297014479.git.pierre.tardy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1297014479.git.pierre.tardy@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

On Sun, Feb 06, 2011 at 07:02:47PM +0100, Pierre Tardy wrote:
> Please find a simple sdhci runtime_pm implementation
> that uses clock gating fw as a tip to know when 
> our chip is idle.
> 
> Previous version was RFC and untested,
> This version has been tested on intel medfield platform.
> 
> Pierre Tardy (2):
>   mmc: put the led blinking code after clock ungating
>   sdhci:v2:use ios->clock to know when sdhci is idle
> 
> Yunpeng Gao (1):
>   sdhci-pci : Enable runtime PM support

Thanks very much, pushed to mmc-next with Linus W's ACK.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
