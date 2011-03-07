Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1CGQg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:36:57 -0500
Received: from imr4.ericy.com ([198.24.6.8]:45162 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1CGQgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:36:55 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Greg Schnorr <gschnorr@cisco.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 0/2] hwmon: (pmbus) Improve temperature sensor support
Date: Mon, 7 Mar 2011 08:38:55 -0800
Message-ID: <1299515937-9138-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches improve temperature sensor support for PMBus devices.
