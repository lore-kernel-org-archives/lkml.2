Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965557Ab2JYJDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:03:16 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:36541 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964967Ab2JYJDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:03:14 -0400
Message-ID: <1351155783.15388.0.camel@phoenix>
Subject: mfd: rc5t583-irq.c build warning: array subscript is above array
 bounds
From: Axel Lin <axel.lin@ingics.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Thu, 25 Oct 2012 17:03:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Laxman,

I got below compile warning when build this driver.

  CC      drivers/mfd/rc5t583-irq.o
drivers/mfd/rc5t583-irq.c: In function 'rc5t583_irq_sync_unlock':
drivers/mfd/rc5t583-irq.c:227: warning: array subscript is above array bounds
drivers/mfd/rc5t583-irq.c: In function 'rc5t583_irq_init':
drivers/mfd/rc5t583-irq.c:349: warning: array subscript is above array bounds

Regards,
Axel


