Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab2GPKmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:42:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:52607 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2GPKmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:42:44 -0400
Message-Id: <20120716103749.122800930@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 16 Jul 2012 10:42:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [Patch 0/7] Per cpu thread hotplug infrastructure - V3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements the infrastructure for parking and
unparking kernel threads to avoid the full teardown and fork on cpu
hotplug operations along with management infrastructure for hotplug
and users.

Changes vs. V2:

 Use callbacks for all functionality. Thanks to Rusty for pointing
 that out. It makes the use sites nice and simple and keeps all the
 code which would be duplicated otherwise on the core.

Thanks,

	tglx

