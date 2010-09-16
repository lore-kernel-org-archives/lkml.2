Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab0IPCCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 22:02:08 -0400
Received: from imr4.ericy.com ([198.24.6.8]:55956 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0IPCCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 22:02:06 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 0/2] hwmon: Replace update_rate sysfs attribute with update_interval
Date: Wed, 15 Sep 2010 19:07:13 -0700
Message-ID: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two sysfs attributes are currently used to reflect sensor reading update
intervals: update_rate and rate. In all uses, the attribute reflects
an interval, not a rate.

To reflect this, replace the sysfs ABI attribute update_rate with
update_interval, and modify affected drivers to use update_interval.
