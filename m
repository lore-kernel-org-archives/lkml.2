Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab2JVBPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 21:15:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49759 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab2JVBPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 21:15:20 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: lars@metafoo.de, cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 0/2 v2] Cleanup battery driver for jz4740
Date: Sun, 21 Oct 2012 23:13:43 -0200
Message-Id: <1350868425-26852-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

This is the second attempt for clean of the battery driver 
of jz4740.

Changelog:
	Path 1/2: Is the same, just added the Acked-by from
			Lars Peter-Clausen
	Path 2/2: use devm_request_and_ioremap, suggested by
			Lars Petr-Clausen

	The third patch about irqs sent before was droped. This will 
	be reworked in the next patches.

I hope you enjoy :)

Marcos Paulo de Souza (2):
  drivers: power: jz4740-battery: Use devm_kzalloc instead of
    kzalloc/kfree
  drivers: power: jz4740_battery: Use devm_request_and_ioremap

 drivers/power/jz4740-battery.c |   35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

-- 
1.7.9.5

