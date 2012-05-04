Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579Ab2EDUHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:07:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37233 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379Ab2EDUHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:07:03 -0400
Date: Fri, 4 May 2012 21:07:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@ardb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: Handling of modular boards
Message-ID: <20120504200659.GQ14230@opensource.wolfsonmicro.com>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
 <201205041934.08830.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205041934.08830.arnd@arndb.de>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 07:34:08PM +0000, Arnd Bergmann wrote:

> One idea that I've heard before is to put device tree fragments into the
> kernel and dynamically add them to the device tree that was passed by the
> boot loader whenever we detect the presence of a specific device.
> This obviously means it works only for boards using DT for booting, but
> it allows us to use some infrastructure that we already have.

I think anything that relies on bootloaders (or DT for that matter) is a
bit of a non-starter for my personal use cases.  Even where we're using
DT relying on a sane bootloader seems a bit scary - my personal use
cases would rely on updating this stuff in the field for non-technical
users who would have trouble recovering from issues.

> An intermediate solution that I really like is the ability to
> stuff device tree fragments on extension board themselves, but that
> can only work for new designs and causes problems when that information
> is not actually correct.

I can see the theory, but I can also see some practical concerns.  And
with the boards I'm working with we currently have 8 bits of data so...
