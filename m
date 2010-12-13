Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab0LMMCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:02:32 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:37186 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab0LMMCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:02:31 -0500
Date: Mon, 13 Dec 2010 13:02:30 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/10] gpio: irq_data conversion.
Message-ID: <20101213120230.GY15575@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set converts drivers/gpio/ irq_chips and flow handlers over
to the new struct irq_data based irq_chip functions.


Lennert Buytenhek (10):
  gpio: adp5588-gpio: irq_data conversion.
  gpio: langwell_gpio: irq_data conversion.
  gpio: max732x: irq_data conversion.
  gpio: pca953x: irq_data conversion.
  gpio: pl061: irq_data conversion.
  gpio: stmpe-gpio: irq_data conversion.
  gpio: sx150x: irq_data conversion.
  gpio: tc35892-gpio: irq_data conversion.
  gpio: timbgpio: irq_data conversion.
  gpio: vr41xx_giu: irq_data conversion.

 drivers/gpio/adp5588-gpio.c  |   39 +++++++++++++++++----------------
 drivers/gpio/langwell_gpio.c |   16 +++++++-------
 drivers/gpio/max732x.c       |   38 ++++++++++++++++----------------
 drivers/gpio/pca953x.c       |   38 ++++++++++++++++----------------
 drivers/gpio/pl061.c         |   28 ++++++++++++------------
 drivers/gpio/stmpe-gpio.c    |   36 +++++++++++++++---------------
 drivers/gpio/sx150x.c        |   46 ++++++++++++++++++++--------------------
 drivers/gpio/tc35892-gpio.c  |   36 +++++++++++++++---------------
 drivers/gpio/timbgpio.c      |   30 +++++++++++++-------------
 drivers/gpio/vr41xx_giu.c    |   48 +++++++++++++++++++++---------------------
 10 files changed, 178 insertions(+), 177 deletions(-)
