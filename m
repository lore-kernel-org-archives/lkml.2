Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0I3W3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 18:29:23 -0400
Received: from void.printf.net ([89.145.121.20]:49670 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab0I3W3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 18:29:22 -0400
Date: Thu, 30 Sep 2010 23:29:19 +0100
From: Chris Ball <cjb@laptop.org>
To: Hanumath Prasad <hanumath.prasad@stericsson.com>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: MMC 4.4 DDR support
Message-ID: <20100930222919.GA29047@void.printf.net>
References: <1278658780-26397-1-git-send-email-hanumath.prasad@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278658780-26397-1-git-send-email-hanumath.prasad@stericsson.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 12:29:40PM +0530, Hanumath Prasad wrote:
> Add support for Dual Data Rate MMC cards as defined in the 4.4
> specification.
> 
> Cc: linux-mmc@vger.kernel.org
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Hanumath Prasad <hanumath.prasad@stericsson.com>

Thanks very much, pushed to mmc-next along with Zhangfei's Tested-By:
and Adrian's fixup patch.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
