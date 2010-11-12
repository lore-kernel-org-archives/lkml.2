Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab0KLUev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:34:51 -0500
Received: from imr3.ericy.com ([198.24.6.13]:46214 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab0KLUet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:34:49 -0500
Subject: Location for thermal drivers
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: linux-kernel@vger.kernel.org
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Fri, 12 Nov 2010 12:33:45 -0800
Message-ID: <1289594026.22931.388.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We have a review for a thermal driver for the Intel MID platform pending
against the hwmon subsystem. See
http://lists.lm-sensors.org/pipermail/lm-sensors/2010-November/030471.html for details.

I think a better location for the driver would be drivers/thermal.
drivers/hwmon is not really a good fit, since hwmon support for thermal
drivers is optional. Potential problem with drivers/thermal is that
there are no thermal drivers in there (yet), and there does not seem to
be a maintainer. Another alternative would be to put it into platform
code, similar to the existing thermal drivers.

Thought, anyone ? Is there a preferred location for thermal drivers ?

Thanks,
Guenter


