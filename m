Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1BFVMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:12:22 -0500
Received: from www.tglx.de ([62.245.132.106]:54805 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab1BFVMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:12:21 -0500
Message-Id: <20110206211051.865188529@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 21:12:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Subject: [patch 0/3] xtensa: Convert to new irq_chip functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series converts xtensa to the new irq_chip functions and
sets GENERIC_HARDIRQS_NO_DEPRECATED

Thanks,

	tglx



