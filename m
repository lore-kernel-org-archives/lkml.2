Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab0LTTQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 14:16:17 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36313 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0LTTQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 14:16:16 -0500
Date: Mon, 20 Dec 2010 19:15:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexey Charkov <alchark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v8] ARM: Add basic architecture support for
	VIA/WonderMedia 85xx SoC's
Message-ID: <20101220191549.GH28157@n2100.arm.linux.org.uk>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <20101107165745.GB1759@n2100.arm.linux.org.uk> <AANLkTimFJ=Brx4pDiUqZOKDfABaDg0s_yFC7EkZGi7D8@mail.gmail.com> <20101107171726.GF1759@n2100.arm.linux.org.uk> <20101108171930.GA1471@alchark-u3s.lan> <20101111212322.GA15533@alchark-u3s.lan> <20101111234957.GA28735@n2100.arm.linux.org.uk> <20101219174017.GA31832@alchark-u3s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101219174017.GA31832@alchark-u3s>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 08:40:17PM +0300, Alexey Charkov wrote:
> +config ARCH_VT8500
> +	bool "VIA/WonderMedia 85xx"
> +	select CPU_ARM926T
> +	select GENERIC_GPIO
> +	select ARCH_HAS_CPUFREQ
> +	select GENERIC_TIME

Everything looks good, except for the above.  You don't need to select
GENERIC_TIME - it doesn't exist anymore.

It's also good to see that you've picked up on registering clocksources
with the _hz/_khz functions.
