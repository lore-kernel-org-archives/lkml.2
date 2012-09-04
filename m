Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2IDIkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:40:21 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:25689 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab2IDIkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:40:19 -0400
Date: Tue, 4 Sep 2012 10:40:06 +0200
Message-Id: <201209040840.q848e6jj028964@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [PATCH 0/2] hwmon/lm70: changes to allow 4w with LM70 and add LM71/LM74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The two following patches do:
1) Allow the use of NS LM70 with a 4 wire SPI bus too, since the component allows both configuration
2) Adds support for NS LM71 and LM74

Regards
Christophe

