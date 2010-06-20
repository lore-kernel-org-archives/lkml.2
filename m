Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab0FTQif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 12:38:35 -0400
Received: from imr1.ericy.com ([198.24.6.9]:46204 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab0FTQid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 12:38:33 -0400
X-Greylist: delayed 93585 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jun 2010 12:38:33 EDT
Date: Sun, 20 Jun 2010 09:37:59 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: Adding critical/fault limits to hwmon sysfs API
Message-ID: <20100620163759.GA7077@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the current hwmon sysfs API does not specify critical or fault limits for voltage
and current readings.

Many recent power controller/monitoring chips have support for such limits in addition
to alarm limits. Typical action, when a the critical or fault limit is reached,
may be a board reset or power shutdown, or to report the fault condition.

Examples for chips supporting critical/fault limits are SMM665 and variants as well
as many PMBus devices, such as MAX8688, MAX16064, LTC2978, and others.

I think it would make sense to add critical/fault limits to the hwmon sysfs API,
to be able to report those limits if supported by a chip.

Any thoughts on this ?

Thanks,
Guenter

