Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0FNKcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 06:32:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53053 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab0FNKcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 06:32:54 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Patch serie for STMPE811 [V2]
Date: Mon, 14 Jun 2010 12:32:35 +0200
Message-Id: <1276511558-27121-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in the following is the V2 patch serie for the stmpe811 chip. Changes are made
all over the place:
* irq management of the core
* configuration parameter passing in the touch screen driver.
* Some additional locking stuff
* i2c client stuff
* formating fix
etc.
See the individual patch header for more details.

thanks

cheers
Luotao Fu

