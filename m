Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab1BFXEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:04:45 -0500
Received: from www.tglx.de ([62.245.132.106]:47653 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab1BFXEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:04:44 -0500
Message-Id: <20110206230305.461141290@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 23:04:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 0/3] tile: Cleanup irq chips and irq_desc accessors
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq chips to the new callback functions and use proper
accessors for irq_desc. Select GENERIC_HARDIRQS_NO_DEPRECATED

Thanks,

	tglx




