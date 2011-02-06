Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1BFQai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:30:38 -0500
Received: from www.tglx.de ([62.245.132.106]:41491 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1BFQai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:30:38 -0500
Message-Id: <20110206162900.250401028@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 16:30:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [patch 0/4] avr32: Convert to new irq_chip functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to new irq_chip functions and cleanup a few open coded
irq_desc accesses.

Thanks,

	tglx







