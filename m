Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1HKTgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:36:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39048 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1HKTgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:36:36 -0400
Date: Thu, 11 Aug 2011 20:36:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: Fix <mach/gpio.h> to have necessary
	#includes
Message-ID: <20110811193607.GA24166@n2100.arm.linux.org.uk>
References: <1313085952-26365-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313085952-26365-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 12:05:52PM -0600, Stephen Warren wrote:
> Without this, EINVAL isn't defined, and type bool isn't declared.
> This leads to compilation failures.

An alternative approach would be to convert tegra to be able to use
the gpiolib __gpio_to_irq() for the on-SoC stuff, and eliminate
irq_to_gpio().

Would it be possible to do that instead?
