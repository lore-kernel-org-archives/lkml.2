Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab3AIL70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:59:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42697 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3AIL7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:59:25 -0500
Date: Wed, 9 Jan 2013 11:59:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 2/3] ARM: ux500: Turn on the 'heartbeat' LED trigger
Message-ID: <20130109115911.GI3931@n2100.arm.linux.org.uk>
References: <1357725965-27342-1-git-send-email-lee.jones@linaro.org> <20130109110840.GD31678@gmail.com> <20130109111209.GH3931@n2100.arm.linux.org.uk> <201301091156.55644.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301091156.55644.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 11:56:55AM +0000, Arnd Bergmann wrote:
> On Wednesday 09 January 2013, Russell King - ARM Linux wrote:
> > > If so, that's wrong, as it covers many more boards than just Snowball
> > > and this is only applicable on the Snowball board. So how else can
> > > I enable this feature?
> > 
> > And why is it wrong to enable an optional feature in a defconfig which some
> > boards using that defconfig may want?
> > 
> > It's less wrong than forcing user selectable options to be mandatorily
> > selected.
> 
> Right. The change I suggested fixes the build errors but doesn't actually
> make the intended behavior correct. Just using a configuration file is the
> right solution here.

Hang on a moment: if the lack of the LEDs support leads to build errors,
doesn't that mean there's missing conditional compilation?
