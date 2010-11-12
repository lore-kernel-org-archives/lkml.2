Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab0KLM7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 07:59:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40368 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab0KLM7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 07:59:20 -0500
Date: Fri, 12 Nov 2010 12:59:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Harald Gustafsson <harald.gustafsson@ericsson.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Colin Cross <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rickard ANDERSSON <Rickard.Andersson@stericsson.com>
Subject: Re: [PATCH] [ARM] twd: Allow twd rescaling to match cpu frequency
Message-ID: <20101112125901.GA3619@n2100.arm.linux.org.uk>
References: <1283396674-4865-1-git-send-email-ccross@android.com> <AANLkTinsRCinLdhq1xj0tx09Jb=Tohdbd7PUD=ae1q3m@mail.gmail.com> <DB5ED9F94071134F8D813944A461CF1A0196031CBA@ESESSCMS0361.eemea.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB5ED9F94071134F8D813944A461CF1A0196031CBA@ESESSCMS0361.eemea.ericsson.se>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 01:49:50PM +0100, Harald Gustafsson wrote:
> Hi,
> 
> Don't forget the other patches to make this work:
> 
> [ARM] twd: Always calibrate local timer
> [ARM] twd: Fix updating control register in set_mode
> [ARM] twd: Fix prescaler getting cleared by set_mode

... which have never been posted to this mailing list, so no one here
knows of them.
