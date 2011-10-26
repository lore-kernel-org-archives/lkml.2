Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1JZVjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:39:33 -0400
Received: from toro.web-alm.net ([62.245.132.31]:59414 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab1JZVjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:39:32 -0400
X-Greylist: delayed 1313 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 17:39:31 EDT
Message-Id: <20111026211415.787299186@osadl.org>
User-Agent: quilt/0.48-1
Date: Wed, 26 Oct 2011 23:14:15 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <C.Emde@osadl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH 0/1] Incorrect name of the idle tasks in SMP kernels v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The command name of the idle tasks in SMP kernels was incorrect which
resulted in misleading trace output. This patch fixes it.

	-Carsten.
