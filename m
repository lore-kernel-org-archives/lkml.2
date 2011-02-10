Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab1BJV5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:57:16 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39458 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab1BJV5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:57:15 -0500
Date: Thu, 10 Feb 2011 13:57:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: benh@kernel.crashing.org, paulus@samba.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH powerpc 0/2] powerpc CONFIG_PREEMPT fixes
Message-ID: <20110210215710.GA18429@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series provides fixes for a couple of CONFIG_PREEMPT problems on
Power:

1.	The hpte_need_flush() function accesses per-CPU variables without
	protection.
2.	The rtas_event_scan() function needs to use raw_smp_processor_id()
	to get a starting point to avoid debugging splats.

There are probably a few more where these came from.  ;-)

								Thanx, Paul
