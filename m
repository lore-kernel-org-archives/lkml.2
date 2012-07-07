Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2GGVA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 17:00:57 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57627 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab2GGVA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 17:00:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] PM / hwmon: Convert platform hwmon drivers to PM handling based on struct dev_pm_ops
Date: Sat, 7 Jul 2012 23:02:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>, Kukjin Kim <kgene.kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207072302.16491.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

As per

http://marc.info/?l=linux-kernel&m=133996733422413&w=4

the following patches convert the platform TPM drivers to the PM handling
based on struct dev_pm_ops:

[1/4] abituguru: Use struct dev_pm_ops for power management.
[2/4] abituguru3: Use struct dev_pm_ops for power management.
[3/4] gpio-fan: Use struct dev_pm_ops for power management.
[4/4] exynos4_tmu: Use struct dev_pm_ops for power management.

Thanks,
Rafael

