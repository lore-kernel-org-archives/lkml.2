Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1BEToy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:44:54 -0500
Received: from www.tglx.de ([62.245.132.106]:60053 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab1BETox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:44:53 -0500
Message-Id: <20110205193740.964969119@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 19:44:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Subject: [patch 0/8] ia64: Convert irq_chips to new functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series converts the interrupt chips to the new
functions.Compile tested only.

Thanks,

	tglx


