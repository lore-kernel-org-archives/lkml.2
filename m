Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1BHEGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 23:06:04 -0500
Received: from void.printf.net ([89.145.121.20]:42106 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab1BHEGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 23:06:02 -0500
Date: Tue, 8 Feb 2011 04:05:58 +0000
From: Chris Ball <cjb@laptop.org>
To: Simon Horman <horms@verge.net.au>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>
Subject: Re: [PATCH] [patch v3] tmio_mmc: Improve readability of the output
	of pr_debug_status()
Message-ID: <20110208040555.GA7832@void.printf.net>
References: <1296856076-2387-1-git-send-email-horms@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296856076-2387-1-git-send-email-horms@verge.net.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Sat, Feb 05, 2011 at 06:47:56AM +0900, Simon Horman wrote:
> --- a/drivers/mmc/host/tmio_mmc.h
> +++ b/drivers/mmc/host/tmio_mmc.h

Mind rebasing against Linus' tree or mmc-next?  Guennadi has merged
tmio_mmc.h into tmio_mmc.c there.

Once the patch applies, I'll merge it into mmc-next with a Reviewed-by:
line from Guennadi unless anyone objects.

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
