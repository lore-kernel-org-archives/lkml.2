Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab1GAMKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:10:04 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:49355 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab1GAMKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:10:01 -0400
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [BUGFIX][PATCH] gpiolib: add missing initialisation of bgc->dir
Date: Fri,  1 Jul 2011 14:08:50 +0200
Message-Id: <1309522131-2237-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bgpio_init() does not initialise the shadow variable for the GPIO_GDIR
register. Thus the first 'set_direction' call will clear the whole
GPIO_GDIR register of the affected GPIO bank.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>

