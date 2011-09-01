Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1IARiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:38:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56394 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab1IARiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:38:06 -0400
Date: Thu, 1 Sep 2011 18:37:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Andrew Chew <achew@nvidia.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH V2 1/4] i2c: Add irq_gpio field to struct i2c_client.
Message-ID: <20110901173756.GA13417@sirena.org.uk>
References: <1314895964-15964-1-git-send-email-swarren@nvidia.com>
 <1314895964-15964-5-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314895964-15964-5-git-send-email-swarren@nvidia.com>
X-Cookie: Vote anarchist.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 10:52:41AM -0600, Stephen Warren wrote:
> Some devices use a single pin as both an IRQ and a GPIO. In that case,
> irq_gpio is the GPIO ID for that pin. Not all drivers use this feature.
> Where they do, and the use of this feature is optional, and the system
> wishes to disable this feature, this field must be explicitly set to a
> defined invalid GPIO ID, such as -1.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

SPI could also benefit from this.
