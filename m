Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0CTPlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 11:41:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60779 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab0CTPlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 11:41:35 -0400
Date: Sat, 20 Mar 2010 15:41:13 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Woodhouse <David.Woodhouse@intel.com>, linux-mtd@lists.infradead.org,
       kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/24] mtd/maps/pismo: remove dangling pointer and a
	leak
Message-ID: <20100320154113.GB14470@flint.arm.linux.org.uk>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-2-git-send-email-w.sang@pengutronix.de> <20100320145729.GA5399@flint.arm.linux.org.uk> <20100320153146.GB5515@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100320153146.GB5515@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 04:31:46PM +0100, Wolfram Sang wrote:
> Subject: [PATCH V2] mtd/maps/pismo: remove dangling pointer and a leak
> 
> While looking for drivers which forgot to clear i2c_clientdata before freeing
> the data structure it points to, I found that the pismo driver even has a leak
> on the probe error path.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

David, are you going to pick this up?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
