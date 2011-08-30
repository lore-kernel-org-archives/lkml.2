Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1H3U6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 16:58:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58040 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756731Ab1H3U6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 16:58:05 -0400
Date: Tue, 30 Aug 2011 21:58:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110830205802.GT2061@opensource.wolfsonmicro.com>
References: <CAOS58YNuCbaOsWBfmjSUsXsArZ5ng6c0B30yswFbRAWkho6L6Q@mail.gmail.com>
 <20110823221314.GL3895@n2100.arm.linux.org.uk>
 <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com>
 <20110825121416.GB8883@n2100.arm.linux.org.uk>
 <20110825121710.GK3286@htj.dyndns.org>
 <20110825122543.GC8883@n2100.arm.linux.org.uk>
 <20110825123542.GM3286@htj.dyndns.org>
 <20110825130414.GE8883@n2100.arm.linux.org.uk>
 <20110825130907.GO3286@htj.dyndns.org>
 <20110825145558.GF8883@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825145558.GF8883@n2100.arm.linux.org.uk>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 03:55:58PM +0100, Russell King - ARM Linux wrote:

> Here's the patch.  As the kernel I've run this against doesn't have the
> change to try_to_freeze(), I added a might_sleep() in do_signal() during
> my testing to verify that it fixes Mark's problem (which it does.)

> Mark, can you test this to make sure it fixes your problem please?

Yes, it resolves the problem for me - thanks!

Tested-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Sorry about the delay, was away for the bank holiday weekend.
