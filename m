Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1EaOEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:04:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56347 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1EaOET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:04:19 -0400
Date: Tue, 31 May 2011 15:03:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/3] plat-nomadik: MTU sched_clock as an option
Message-ID: <20110531140357.GD21382@n2100.arm.linux.org.uk>
References: <1306830623-9504-1-git-send-email-mattias.wallin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306830623-9504-1-git-send-email-mattias.wallin@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 10:30:23AM +0200, Mattias Wallin wrote:
> This patch makes it possible to configure away the sched_clock
> part of the MTU timer.

We really need better changelogs than this.  Rather than saying just what
the patch is doing, please also say _why_ the change is required - you
can't expect people reading the patch to guess that kind of thing.
