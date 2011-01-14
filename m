Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab1ANARu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:17:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137Ab1ANARr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:17:47 -0500
Date: Thu, 13 Jan 2011 16:17:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warnings in Linus' tree
Message-Id: <20110113161700.a82a0ae2.akpm@linux-foundation.org>
In-Reply-To: <20110114110952.bb7d6f37.sfr@canb.auug.org.au>
References: <20110114110952.bb7d6f37.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011 11:09:52 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> drivers/net/wireless/p54/p54spi.c:642: warning: ignoring return value of 'gpio_direction_input', declared with attribute warn_unused_result
> 
> Introduced by commit 0fdae42d361bbb431ca0ab0efed5126a94821177 ("gpiolib:
> annotate gpio-intialization with __must_check").

Complete brainfart - I meant to drop that patch ages ago.
