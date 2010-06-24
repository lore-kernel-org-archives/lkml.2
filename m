Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0FXAJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 20:09:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41674 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab0FXAJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 20:09:20 -0400
Date: Thu, 24 Jun 2010 01:09:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] Adding critical/fault limits to hwmon sysfs API
Message-ID: <20100624000916.GA8809@sirena.org.uk>
References: <20100620163759.GA7077@ericsson.com> <20100623144346.10acd898@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623144346.10acd898@hyperion.delvare>
X-Cookie: No purchase necessary.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 02:43:46PM +0200, Jean Delvare wrote:

> For temperatures, we have temp[1-*]_crit, for the critical limit on the
> high end. We don't have a name for the critical limit on the low end,
> because no chip ever implemented that. The name we chose doesn't offer

FWIW battery monitoring chips are likely to implement under temperature
warnings - the Wolfson chargers do, for example.  Low temperature can be
as problematic as high temperature for the chemistry.
