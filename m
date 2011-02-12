Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476Ab1BLDw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 22:52:29 -0500
Received: from imr3.ericy.com ([198.24.6.13]:51581 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758200Ab1BLDw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 22:52:28 -0500
Date: Fri, 11 Feb 2011 19:51:38 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Andres Salomon <dilinger@queued.net>
CC: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 03/17] jz4740: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110212035138.GA6859@ericsson.com>
References: <20110211180250.483936cc@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110211180250.483936cc@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 09:02:50PM -0500, Andres Salomon wrote:
> 
> No need to explicitly set the cell's platform_data/data_size.
> 
> Modify clients to use mfd_get_cell helper function instead of
> accessing platform_data directly.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

I don't see anything different to the previous version of this patch
(which was Acked by Jean already), and there is no changelog available
for the complete series either.

A changelog would be really helpful.

Guenter
