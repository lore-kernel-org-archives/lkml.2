Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2JRXlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:41:32 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56212 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2JRXlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:41:31 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: lars@metafoo.de, cbou@mail.ru, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 0/4] driver/power/jz4740-battery: driver cleanup
Date: Thu, 18 Oct 2012 20:41:00 -0300
Message-Id: <1350603664-18148-1-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

This patchset is just a cleanup using devm_* functions. They were
tested in Dingoo A320 for two days, without any problems.

I hope you enjoy :)

Marcos Paulo de Souza (4):
  Use devm_kzalloc instead of kzalloc/kfree
  Use devm_* for reques_mem_region and ioremap
  Use devm_request_irq to avoid some checks
  power/jz4740.c: Simplify exit of function

 drivers/power/jz4740-battery.c |   53 ++++++++++++----------------------------
 1 file changed, 15 insertions(+), 38 deletions(-)

-- 
1.7.9.5

