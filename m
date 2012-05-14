Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab2ENQs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:48:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:52280 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab2ENQs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:48:27 -0400
From: Benedikt Spranger <b.spranger@linutronix.de>
To: hjk@hansjkoch.de
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        magnus.damm@gmail.com, Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH] uio_pdrv_genirq: configure irq through platform resource
Date: Mon, 14 May 2012 18:48:16 +0200
Message-Id: <1337014097-5034-1-git-send-email-b.spranger@linutronix.de>
X-Mailer: git-send-email 1.7.9.1
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform driver uio_pdrv_genirq use its own method to configure the
interrupt number. Instead of using the common way via platform resource the
interrupt number is passed through the platform_data. Parse also the interrupt
resource to allow a platform device to pass the interrupt number via
platform resource.

Benedikt Spranger (1):
  uio_pdrv_genirq: get irq through platform resource if not set
    otherwise

 drivers/uio/uio_pdrv_genirq.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

-- 
1.7.9.1

