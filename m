Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab0CTO5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:57:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38912 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab0CTO5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:57:52 -0400
Date: Sat, 20 Mar 2010 14:57:30 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       David Woodhouse <David.Woodhouse@intel.com>,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 01/24] mtd/maps/pismo: remove dangling pointer and a
	leak
Message-ID: <20100320145729.GA5399@flint.arm.linux.org.uk>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-2-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269094385-16114-2-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 03:12:42PM +0100, Wolfram Sang wrote:
> + exit_free:
> +	i2c_set_clientdata(client, NULL);
> +	kfree(prismo);

And this is a compile error...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
