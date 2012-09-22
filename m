Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2IVQLh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 12:11:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58376 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664Ab2IVQLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 12:11:36 -0400
Date: Sat, 22 Sep 2012 12:11:33 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH resend] spi core: Provide means to instantiate devices
 through sysfs
Message-ID: <20120922161133.GU4495@opensource.wolfsonmicro.com>
References: <1347925880-13076-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347925880-13076-1-git-send-email-linux@roeck-us.net>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 04:51:20PM -0700, Guenter Roeck wrote:
> The I2C core provides a means to instantiate devices from userspace
> using sysfs attributes. Provide the same mechanism for SPI devices.

So, unlike I2C this is only going to work for a subset of controllers -
anything that relies on GPIOs for chip select will need more data to add
the chip selects for example.  This means I'm having a hard time getting
enthused about the idea, it seems like it might be a support burden.
