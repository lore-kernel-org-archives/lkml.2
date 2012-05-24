Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab2EXRyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:54:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:57198 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2EXRyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:54:54 -0400
Message-Id: <20120524174943.989990966@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 24 May 2012 17:54:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chen Gong <gong.chen@linux.intel.com>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 0/2] x86: mce: Implement poll mode for CMCI
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements poll mode for CMCI after cleaning up the timer mess in
mce.

Note this is completely untested, but at least it compiles.

Thanks,

	tglx



