Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab2GPIHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:07:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:51907 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2GPIHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:07:44 -0400
Message-Id: <20120715090141.942753287@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 16 Jul 2012 08:07:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: RT-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [patch RT 0/3] Stable rt updates - part II
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

please pick the following three patches which address the CPU hotplug
nightmare on RT.

I still hate them, but we want to have that addressed in the stable
series.

Aside of that there are the outstanding issues with btrfs and io unplug.

The missing spin_lock_init() fix should reach you via mainline stable
updates. Mike and Chris are looking into that interesting locking
features.

The io unplug thing stays mysterious, but as I just wrote in that
thread, my patch to address it is fundamentally wrong. :(

I'm off for a week of vacation, so do not expect any further updates
from my side. If Mike and Chris come up with an agreed solution for
the locking issue, please pick it up yourself.

Thanks,

	tglx

