Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab1BFWYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:24:16 -0500
Received: from www.tglx.de ([62.245.132.106]:50029 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab1BFWYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:24:14 -0500
Message-Id: <20110206222131.508619512@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 22:23:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Subject: [patch 0/2] score: Convert irq_chip to new functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series converts the irq_chip in arch/score to the new callback
functions and uses the proper accessor functions in show_interrupts().
Finally it sets GENERIC_HARDIRQS_NO_DEPRECATED

Thanks,

	tglx


