Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1K0Rum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 12:50:42 -0500
Received: from imr3.ericy.com ([198.24.6.13]:49721 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab1K0Rul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 12:50:41 -0500
Date: Sun, 27 Nov 2011 09:48:49 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Marc Pignat <marc.pignat@hevs.ch>, Paul Thomas <pthomas8589@gmail.com>,
        Eric Miao <eric.miao@marvell.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon: convert drivers/hwmon/* to use module_spi_driver()
Message-ID: <20111127174849.GA31315@ericsson.com>
References: <1322205165.11718.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1322205165.11718.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 02:12:45AM -0500, Axel Lin wrote:
> This patch converts the drivers in drivers/hwmon/* to use the
> module_spi_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Sonic Zhang <sonic.zhang@analog.com>
> Cc: Marc Pignat <marc.pignat@hevs.ch>
> Cc: Paul Thomas <pthomas8589@gmail.com>
> Cc: Eric Miao <eric.miao@marvell.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

module_spi_driver() is not (yet) available in mainline, so this patch
can not be applied right now.

It would probably make sense to resubmit the patch once the code necessary
to support it is available, to make sure it does not miss any new drivers.

Guenter
