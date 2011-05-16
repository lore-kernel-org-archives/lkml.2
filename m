Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab1EPNJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:09:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48672 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab1EPNJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:09:19 -0400
Date: Mon, 16 May 2011 14:09:05 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, alan@linux.intel.com
Subject: Re: [PATCH 2/2] amba pl011: platform data for reg lockup and glitch
Message-ID: <20110516130905.GA12192@flint.arm.linux.org.uk>
References: <1305550879-28945-1-git-send-email-shreshthakumar.sahu@stericsson.com> <1305550879-28945-2-git-send-email-shreshthakumar.sahu@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305550879-28945-2-git-send-email-shreshthakumar.sahu@stericsson.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 06:31:19PM +0530, Shreshtha Kumar SAHU wrote:
> From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> 
> This patch provides platform data for following
>  - uart reset function to assist uart register lockup workaround
> 
>  - init/exit function to fix glitch in the tx pin in tty_open
> 	when tty port0 is opened a glitch is seen in the tx line
> 	of uart0. This happens in __pl011_startup() when tx fifo
> 	interrupt is provoked into asserting.

I was trying to work out where that is, but i can't find this function.
Is your patch against a different version of the driver?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
