Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1CQTcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:32:50 -0400
Received: from www.tglx.de ([62.245.132.106]:44770 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1CQTct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:32:49 -0400
Message-Id: <20110317192247.722047296@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 17 Mar 2011 19:32:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [patch 0/5] gpio: langwell: Cleanup the interrupt mess
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The langwell interrupt handler is interesting and breaks when an
architecture enables GENERIC_HARDIRQS_NO_DEPRECATED.

Also this driver along with the other intel ones should depend on x86.

The series cleans that up. The last patch 5/5 is RFC and needs a
close look and testing by folks at Intel.

Thanks,

	tglx

