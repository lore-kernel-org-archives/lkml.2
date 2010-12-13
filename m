Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab0LMNv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:51:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32877 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab0LMNvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:51:55 -0500
Date: Mon, 13 Dec 2010 13:51:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, Linus Walleij <linus.ml.walleij@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>, john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: timer: Separate clocksource and sched_clock
Message-ID: <20101213135110.GL8665@n2100.arm.linux.org.uk>
References: <1290039615-23407-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290039615-23407-1-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 04:20:15PM -0800, Colin Cross wrote:
> tegra_clocksource_read should not use cnt32_to_63, wrapping is
> already handled in the clocksource code.  Move the cnt32_to_63
> into the sched_clock function, and replace the use of clocksource
> mult and shift with a multiplication by 1000 to convert us to ns.

Colin,

Mind if I pick this up into my tree - I'm doing other work with
clocksources and sched_clock() at the moment which will clash with
this patch.

Thanks.
