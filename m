Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab2KFXLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:11:36 -0500
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47688 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2KFXLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:11:35 -0500
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: cbou@mail.ru, dwmw2@infradead.org, lars@metafoo.de,
        linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 0/2 v3] jz4740-battery module cleanup
Date: Tue,  6 Nov 2012 21:11:10 -0200
Message-Id: <1352243472-14951-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys!

This is the third version of the simple(simple..?) cleanup in the 
battery driver of jz4740. Just a tiny cleanup.

These patches were tested in Dingoo A320, without any problems.

Added Acked-bys of Lars.

Thanks since now!

Changelog:
	From v2:
		Remove the patch that touches the irq_request. We need
		to take a look at this later.

		Remove the mem member of the struct jz_battery. Now this
		data is useless.

	From v1:
		Use devm_request_and_ioremap instead of
		devm_request and devm_ioremap_nocache.

Marcos Paulo de Souza (2):
  drivers/power/jz4740-battery.c: Use devm_kzalloc
  drivers/power/jz4740-battery.c: Use devm_request_and_ioremap

 drivers/power/jz4740-battery.c |   41 ++++++++--------------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

-- 
1.7.9.5

