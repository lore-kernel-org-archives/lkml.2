Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030311Ab2GKWFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:05:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:35489 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2GKWFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:05:19 -0400
Message-Id: <20120711214552.036760674@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 11 Jul 2012 22:05:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        RT-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <cbe@osadl.org>
Subject: [patch RT 0/7] Various fixes for the stable RT series - part I
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series is a collection of bug fixes, which should
go into the 3.x based stable RT trees.

I have them locally applied to my 3.5 devel queue, but I'm still
distracted by other events (leap seconds and the like) to get a 3.5
devel queue released.

Steven, please pick up the lot.

I have a part II series pending which is addressing the widely
observed CPU hotplug issue. I'm going to send that out soon, despite
the fact that I fundamentaly hate it. Though the hotplug rework which
I have in the queue has turned out to be more work than expected and
there is no real way to backport all of the necessary changes into any
of the existing 3.x based RT trees. So I bite the bullet and go with
the workarounds to get rid of the last obstacles in the 3.x based RT
series.

Thanks,

	tglx



