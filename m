Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1HAXqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:46:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55034 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab1HAXqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:46:49 -0400
Date: Tue, 2 Aug 2011 00:46:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Timur Tabi <timur@freescale.com>
Cc: arnd@arndb.de, grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/misc: introduce Freescale Data Collection
 Manager driver
Message-ID: <20110801234645.GA15792@sirena.org.uk>
References: <1312235334-15036-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312235334-15036-1-git-send-email-timur@freescale.com>
X-Cookie: Thufir's a Harkonnen now.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 04:48:54PM -0500, Timur Tabi wrote:
> The Data Collection Manager (DCM) is a feature of the FPGA on some Freescale
> PowerPC reference boards that can read temperature, current, and voltage
> settings from the sensors on those boards.  This driver exposes the DCM via a
> sysfs interface (/sys/devices/platform/fsl-ocm.0).

This sounds like it should be a hwmon driver.

> The DCM collects and tallies data over a period of time in the background,
> without utilizing any resources on the host (CPU, memory, etc).  The data is
> summarized and made available when data collection stops.  This allows power
> consumption to be measured while the host is performing some tasks (usually
> a benchmark).

Though this is a bit odd for the subsystem I don't think it's too far
out of what other hwmon chips can do, some of them do have longer term
stats than just instantaneous readings.
