Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486Ab1EXXGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:06:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38902 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab1EXXGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:06:01 -0400
Date: Wed, 25 May 2011 00:05:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/4] gpio: move Nomadik GPIO driver to drivers/gpio
Message-ID: <20110524230546.GC4652@n2100.arm.linux.org.uk>
References: <1306271221-28978-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306271221-28978-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 11:07:01PM +0200, Linus Walleij wrote:
> -config NOMADIK_GPIO
> -	bool
> -	help
> -	  Support for the Nomadik GPIO controller.
> -

What about the statements which select this config symbol?
