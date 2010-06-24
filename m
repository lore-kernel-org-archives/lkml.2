Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0FXLOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 07:14:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52560 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab0FXLOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 07:14:11 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: Rabin VINCENT <rabin.vincent@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: mfd: STMPExxxx fixes and touch screen support
Date: Thu, 24 Jun 2010 13:13:35 +0200
Message-Id: <1277378021-16802-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100622135635.GA30720@bnru02.bnr.st.com>
References: <20100622135635.GA30720@bnru02.bnr.st.com>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

I merged your stmpexxx patches and tested them on my board with a stmpe811 chip
(gpio + touchscreen).

In the following are few fixes for the gpio driver. In the serie is also the V4
of my stmpe touchscreen driver, which is now converted to the stmpexxx core.
There appears to be two stmpe variants with a touchscreen controller: stmpe811
and stmpe610. I checked briefly the datasheet of stmpe610. It appears to be, as
far as I can see, identical with stmpe811. Hence I think that the stmpe-ts should
work for the stmpe610 too. Since I don't have a stmpe610 here, I didn't add the
stmpe610 support to the core. Maybe someone out there has possiblities to test
stmpe610, should not be too hard to add support for the chip to the core.

cheers
Luotao Fu

