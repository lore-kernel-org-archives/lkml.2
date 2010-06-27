Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0F0KVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 06:21:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35220 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab0F0KV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 06:21:28 -0400
Date: Sun, 27 Jun 2010 11:20:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Hans de Goede <hdegoede@redhat.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Message-ID: <20100627102058.GB2845@sirena.org.uk>
References: <1277416861-32494-1-git-send-email-guenter.roeck@ericsson.com>
 <1277416861-32494-2-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277416861-32494-2-git-send-email-guenter.roeck@ericsson.com>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.240.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/4] hwmon: Driver for SMM665 Six-Channel Active DC
 Output Controller/Monitor
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 03:00:58PM -0700, Guenter Roeck wrote:
> This driver adds support for the monitoring features of the Summit
> Microelectronics SMM665 Six-Channel Active DC Output Controller/Monitor.

A bit late to the game here but this looks like the chip has some
regulator control functionality as well as monitoring functionality (and
the product page on the Summit web site suggests so also).  This means
that when fully supported in software the driver would cross multiple
subsystems so it might make sense to start off with a MFD rather than
direct I2C control?  

If the non-monitoring functionality can't be controlled from software
this isn't an issue.
