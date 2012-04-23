Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab2DWJRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:17:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41025 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2DWJRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:17:54 -0400
Date: Mon, 23 Apr 2012 10:17:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 5/9] gpio/nomadik: use typesafe __io_address()
Message-ID: <20120423091733.GJ24211@n2100.arm.linux.org.uk>
References: <1335172482-27648-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335172482-27648-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 11:14:42AM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> We were using a custom io_p2v() (physical-to-virtual) translation
> macro, but with the advent of the cross-platform __io_address()
> let us try to get rid of this. Inspired by a similar patch by
> Jonas Aberg.

Is there any point to io_p2v() or __io_address() anymore?  Won't ioremap()
do here?
