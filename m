Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab2K2UIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:08:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52619 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2K2UI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:08:29 -0500
Date: Thu, 29 Nov 2012 20:07:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "arm@kernel.org" <arm@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [GIT PULL] ARM: final SoC fixes for 3.7
Message-ID: <20121129200708.GN19440@n2100.arm.linux.org.uk>
References: <201211291424.25711.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211291424.25711.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:24:25PM +0000, Arnd Bergmann wrote:
> Hi Linus,
> 
> These should be the last bug fixes you get from Olof and me for 3.7.
> This is based on the previous one you pulled and there is nothing
> spectacular in here. I'll follow up with a second pull request
> knowing that those are probably too late now, but I'd like to let
> you know about the ones that didn't make it and give you the chance
> to pull those anyway if you prefer.

I don't see anything in here for the OMAP warning that I've been reporting
for the last two weeks.  What's going on with getting fixes merged into
arm-soc?
