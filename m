Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1BPNAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:00:11 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41481 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106Ab1BPNAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:00:09 -0500
X-Sasl-enc: v+d8vpQLokb+iE8IWBQh2OYtMeMvw4fPoABiMIWGCT71 1297861207
Message-ID: <4D5BCA87.7010204@ladisch.de>
Date: Wed, 16 Feb 2011 14:00:55 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] hwmon: some jc42 changes
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some small bugfixes and enhancements.

 Documentation/hwmon/jc42 |   21 +++++++++++++++------
 drivers/hwmon/Kconfig    |   11 ++++++-----
 drivers/hwmon/jc42.c     |   35 ++++++++++++++++++++++++++++++-----
 3 files changed, 51 insertions(+), 16 deletions(-)
