Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0FAUNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:13:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754295Ab0FAUNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:13:14 -0400
Date: Tue, 1 Jun 2010 13:12:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hemanth V" <hemanthv@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>, Jonathan Cameron <jic23@cam.ac.uk>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH V2] misc : ROHM BH1780GLI Ambient light sensor Driver
Message-Id: <20100601131244.7164b43c.akpm@linux-foundation.org>
In-Reply-To: <39216.10.24.255.17.1274699065.squirrel@dbdmail.itg.ti.com>
References: <39216.10.24.255.17.1274699065.squirrel@dbdmail.itg.ti.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I re-added your reviewers to the cc...

On Mon, 24 May 2010 16:34:25 +0530 (IST)
"Hemanth V" <hemanthv@ti.com> wrote:

> This patch adds support for ROHM BH1780GLI Ambient light sensor.
> 
> BH1780 supports I2C interface. Driver supports read/update of power state and
> read of lux value (through SYSFS). Writing value 3 to power_state enables the
> sensor and current lux value could be read.

There are at least two other ambient light sensor drivers:
drivers/misc/isl29003.c and drivers/misc/tsl2550.c.

Is there any standardisation of the ABIs whcih these drivers offer?  If
so, does this new driver comply with that?

It would be most useful if the changelog were to fully describe the
proposed kernel<->userspace interface.  That's the most important part
of the driver, because it's the only part we can never change.

There is a desultory effort to maintain sysfs API descriptions under
Documentation/ABI/.  I'd have thought that it would be appropriate to
document this driver's ABI in there.

