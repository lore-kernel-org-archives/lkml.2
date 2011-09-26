Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab1IZP0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:26:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59025 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045Ab1IZP0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:26:36 -0400
Date: Mon, 26 Sep 2011 16:26:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Dilan Lee <dilee@nvidia.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Message-ID: <20110926152634.GN2946@opensource.wolfsonmicro.com>
References: <20110922184614.25419.84606.stgit@ponder>
 <20110926141643.GK2946@opensource.wolfsonmicro.com>
 <20110926151210.GO22455@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110926151210.GO22455@n2100.arm.linux.org.uk>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 04:12:10PM +0100, Russell King - ARM Linux wrote:
> On Mon, Sep 26, 2011 at 03:16:43PM +0100, Mark Brown wrote:

> > used but it's not a blocker for anything.  Devices doing this would need
> > some way to figure out if they should -EBUSY or fail otherwise.

> Just to avoid confusion - ITYM -EAGAIN there.  -EBUSY is already used
> by drivers to mean "someone else claimed a resource I need" be it the
> IO region or an IRQ resource...

Yes, I do - sorry.
