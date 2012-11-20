Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab2KTIRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:17:40 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:49559 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2KTIRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:17:23 -0500
Date: Tue, 20 Nov 2012 09:17:11 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Josh Cartwright <josh.cartwright@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 2/2] ARM: tegra: move timer.c to drivers/clocksource/
Message-ID: <20121120091711.2609af06@skate>
In-Reply-To: <20121120005036.GA6280@kryptos>
References: <1353371237-2482-1-git-send-email-swarren@wwwdotorg.org>
	<1353371237-2482-2-git-send-email-swarren@wwwdotorg.org>
	<20121120005036.GA6280@kryptos>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh,

On Mon, 19 Nov 2012 18:50:36 -0600, Josh Cartwright wrote:

> I had suggested this with Thomas Petazzoni's consolidated irq_chip patch
> as well:
> 
> It seems like it would be a bit cleaner/easier to maintain if we relied
> on the linker to stitch together a clksrc_of_match table, based on what
> clocksources are being built into the image.  With that approach, at
> least, a public initialization header wouldn't have to be exposed, and
> this central table wouldn't have to be maintained (as more clocksrcs are
> added, I forsee [admittedly trivial] merge conflicts).

... and I indeed have a new version of my irqchip patches that indeed
use the linker to merge together the of_device_id entries!

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
