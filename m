Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1HPPkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:40:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34271 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751426Ab1HPPka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:40:30 -0400
Date: Wed, 17 Aug 2011 00:40:22 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Brown <davidb@codeaurora.org>,
        Kenneth Heitke <kheitke@codeaurora.org>, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20110816154021.GC15484@opensource.wolfsonmicro.com>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
 <201108161537.28612.arnd@arndb.de>
 <20110816135051.GA22227@huya.qualcomm.com>
 <201108161632.22255.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108161632.22255.arnd@arndb.de>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 04:32:21PM +0200, Arnd Bergmann wrote:

> That would definitely be helpful. Also, I'd be very interested to hear
> what kind of device probing is available on slimbus. If Mark was
> right about devices being discoverable, we need don't need any board
> description (dts or hardcoded) but instead a way to match the devices
> to drivers based on their HW ID.

I wouldn't go that far - apart from anything else this is designed for
deployment into cellphones and simlar high end systems where you've got
external components to bolt on somehow, and as we're only just starting
to see silicon coming onto the market we'll have to see exactly what
things look like.  This stuff is intended for markets where people bolt
their systems together in very custom ways so automatic discovery is not
a high priority.
