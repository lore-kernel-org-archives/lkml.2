Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab0KLQM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:12:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51474 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569Ab0KLQM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:12:28 -0500
Date: Fri, 12 Nov 2010 16:12:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/kernel/smp_twd.c: Correct local timer printk
	decimal output
Message-ID: <20101112161210.GA10125@n2100.arm.linux.org.uk>
References: <1289244455.29216.348.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289244455.29216.348.camel@Joe-Laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 11:27:35AM -0800, Joe Perches wrote:
> The timer decimal place is shown incorrectly.
> The %100 divisor needs to have 1 fewer 0.
> 
> Convert to pr_<level> while at it.

I'd rather avoid core code having KBUILD_MODNAME prefix it.  The message
is unique enough as is.
