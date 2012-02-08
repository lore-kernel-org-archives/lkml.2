Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2BHTYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:24:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58341 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab2BHTYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:24:40 -0500
From: Marc Kleine-Budde <mkl@blackshift.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] ARM: ixp4xx: fix compilation and oops
Date: Wed,  8 Feb 2012 20:24:27 +0100
Message-Id: <1328729069-21308-1-git-send-email-mkl@blackshift.org>
X-Mailer: git-send-email 1.7.4.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@blackshift.org
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this patch series targets current linus master (v3.3-rc2-230-gc2e50e3). It
fixes compilation of several boards of the ARM ixp4xx architecture and
a boot oops.

With these patches applied I my nslu boots fine.

Please consider to applpy this series to the upcoming v3.3 kernel.

Regards, Marc

