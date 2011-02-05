Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab1BEKrX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 05:47:23 -0500
Received: from www.tglx.de ([62.245.132.106]:32875 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab1BEKqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 05:46:47 -0500
Message-Id: <20110205104025.559237313@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 10:46:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Feng Tang <feng.tang@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Alan Cox <alan@linux.intel.com>, Alek Du <alek.du@intel.com>
Subject: [patch 0/3] platform-drivers: x86: Cleanup pmic gpio interrupt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I stumbled over this gem when looking through the drivers which are
not yet converted to the new irq_chip functions.

Thanks,

	tglx


