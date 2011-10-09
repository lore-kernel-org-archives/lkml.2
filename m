Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab1JIFq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 01:46:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43357 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab1JIFqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 01:46:55 -0400
From: Michael Opdenacker <michael.opdenacker@linaro.org>
To: tony@atomide.com, linux@arm.linux.org.uk, khilman@ti.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: [PATCH 0/1] arm: omap: remove obsolete IRQF_DISABLED 
Date: Sun,  9 Oct 2011 07:46:37 +0200
Message-Id: <1318139198-6865-1-git-send-email-michael.opdenacker@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all occurrences of IRQF_DISABLED in the OMAP tree.
This flag is deprecated and obsolete and as IRQ handlers now run
with all interrupts disabled since 2.6.36

