Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0FXGeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 02:34:36 -0400
Received: from bamako.nerim.net ([62.4.17.28]:55648 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab0FXGee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 02:34:34 -0400
Date: Thu, 24 Jun 2010 08:34:31 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] Adding critical/fault limits to hwmon sysfs API
Message-ID: <20100624083431.6487e7fe@hyperion.delvare>
In-Reply-To: <20100624000916.GA8809@sirena.org.uk>
References: <20100620163759.GA7077@ericsson.com>
	<20100623144346.10acd898@hyperion.delvare>
	<20100624000916.GA8809@sirena.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 01:09:17 +0100, Mark Brown wrote:
> On Wed, Jun 23, 2010 at 02:43:46PM +0200, Jean Delvare wrote:
> 
> > For temperatures, we have temp[1-*]_crit, for the critical limit on the
> > high end. We don't have a name for the critical limit on the low end,
> > because no chip ever implemented that. The name we chose doesn't offer
> 
> FWIW battery monitoring chips are likely to implement under temperature
> warnings - the Wolfson chargers do, for example.  Low temperature can be
> as problematic as high temperature for the chemistry.

We already have temp[1-*]_min. We would have to add temp[1-*]_lcrit
only if a chip has 2 lower limits, one which is only a warning and one
which is critical.

-- 
Jean Delvare
