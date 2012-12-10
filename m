Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2LJWi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:38:29 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47162 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2LJWi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:38:27 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC] gpiolib: introduce descriptor-based GPIO interface
To: Alex Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
In-Reply-To: <1985305.LiOKDTFPq4@percival>
References: <1354779918-4028-1-git-send-email-acourbot@nvidia.com> <1354779918-4028-2-git-send-email-acourbot@nvidia.com> <20121206144259.136693E0950@localhost> <1985305.LiOKDTFPq4@percival>
Date: Mon, 10 Dec 2012 22:34:25 +0000
Message-Id: <20121210223425.DC2783E0796@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2012 11:06:34 +0900, Alex Courbot <acourbot@nvidia.com> wrote:
> On Thursday 06 December 2012 22:42:59 Grant Likely wrote:
> > how about "gpio_chip_hwnum()" to somewhat match irqdomain convention?
> 
> Sure, matching existing interfaces is better. "git grep hwnum" does not seem 
> to reveal much related to irqdomain though?

irqdomain actually uses "hwirq". "hwgpio" would be a closer analog than
'hwnum'.  At first I though hwgpio to be too goofy, but on further
reflection it probably has the least likelyhood of getting used
incorrectly.

g.

