Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab1IZDi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 23:38:57 -0400
Received: from imr3.ericy.com ([198.24.6.13]:56661 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab1IZDi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 23:38:56 -0400
Date: Sun, 25 Sep 2011 20:37:40 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: lm-sensors@lm-sensors.org
CC: Rene Herman <rene.herman@gmail.com>, linux-kernel@vger.kernel.org
Subject: CONFIG_THERMAL_HWMON configuration option removal
Message-ID: <20110926033740.GA5637@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just noticed the folllowing in feature-removal-schedule.txt:

What:   CONFIG_THERMAL_HWMON
When:   January 2009
Why:    This option was introduced just to allow older lm-sensors userspace
        to keep working over the upgrade to 2.6.26. At the scheduled time of
        removal fixed lm-sensors (2.x or 3.x) should be readily available.
Who:    Rene Herman <rene.herman@gmail.com>

I don't know what the lm-sensors changes are, and if they have been implemented.
Is it time to remove the configuration option ?

Thanks,
Guenter
