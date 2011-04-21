Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab1DUHcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 03:32:45 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:16448 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753037Ab1DUHco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 03:32:44 -0400
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: <linux-kernel@vger.kernel.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: <toshiharu-linux@dsn.okisemi.com>
Subject: Question: GPIO driver how to get irq_base
Date: Thu, 21 Apr 2011 16:32:42 +0900
Message-ID: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acv/9kvE7R9IL59aR0GChqLCrpNnJQ==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi GPIO maintainer,

Need your help.
I want to add interrupt function to gpio/pch_gpio.c

According to other upstreamed GPIO driver, (e.g. pl061, langwell, etc...)
2 IRQs(irq, irq_base) are used.

I can get "irq" from (struct pci_dev *)pdev->irq.
However I can't understand where can I get the "irq_base".
Let me know how to get.

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

