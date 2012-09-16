Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab2IPRuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 13:50:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab2IPRuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 13:50:22 -0400
Date: Sun, 16 Sep 2012 19:52:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] uprobes: mprotect fixes
Message-ID: <20120916175210.GA32337@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

_register/_unregister doesn't work correctly if the probed
application plays with mprotect.

Oleg.

 kernel/events/uprobes.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

