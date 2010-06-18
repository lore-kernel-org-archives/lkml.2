Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab0FRQI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 12:08:58 -0400
Received: from imr3.ericy.com ([198.24.6.13]:41167 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758999Ab0FRQIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 12:08:52 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3} hwmon: Driver for SMM665 Six-Channel Active DC Output Controller/Monitor
Date: Fri, 18 Jun 2010 09:06:31 -0700
Message-ID: <1276877194-28214-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for the hardware monitoring features of the Summit
Microelectronics SMM665 Six-Channel Active DC Output Controller/Monitor.

Issues/questions/notes:
- Some of the command register enum values are currently unused.
  Keep or remove ?
- Critical voltage values are not supported by the current sysfs API,
  though available from the chip. Would it make sense to report those values,
  e.g. as inX_min_crit and inX_max_crit ? 
  Note: This also applies to PMBus chips, so the question will come up again.
- It would be nice to be able to support other variants of this chip,
  but I have no means to test it. Some test coverage by others would be helpful.

