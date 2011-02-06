Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1BFWpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 17:45:41 -0500
Received: from www.tglx.de ([62.245.132.106]:59966 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab1BFWpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 17:45:40 -0500
Message-Id: <20110206224358.096841291@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 22:45:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>
Subject: [patch 0/4] UML: Convert irq_chips and use proper accessors
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the irq_chips to the new functions and use proper accessor
functions for irq_desc. Finally set GENERIC_HARDIRQS_NO_DEPRECATED

Thanks,

	tglx

