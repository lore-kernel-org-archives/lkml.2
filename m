Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0IVPd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 11:33:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41082 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab0IVPd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 11:33:26 -0400
Date: Wed, 22 Sep 2010 16:33:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100922153321.GD32476@sirena.org.uk>
References: <20100920140049.31408.67527.stgit@localhost.localdomain> <20100920150431.GD31167@sirena.org.uk> <20100920152726.68ac2d84@linux.intel.com> <20100920152705.GJ3414@rakim.wolfsonmicro.main> <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com> <1285168933.4498.119.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285168933.4498.119.camel@i7.infradead.org>
X-Cookie: They just buzzed and buzzed...buzzed.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 04:22:13PM +0100, David Woodhouse wrote:

> It makes *no* sense to add probe support for your 'special' platform
> devices to drivers which already have (or will need anyway) proper
> device-tree support.

To be fair they're not doing this, all this code is in the arch code
rather than the driver code (which is a separate concern).

> Seriously, just convert whatever crap you have into a device-tree at
> early boot (or preferably in the bootloader, and *beat* the firmware
> idiots until they provide it natively), and don't pollute the kernel any
> more than you have to with this idiocy.

This is roughly what it's doing except that it's going to native Linux
bus types and platform data rather than to device tree.
