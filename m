Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab2GILr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:47:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:47599 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2GILrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:47:18 -0400
Message-ID: <1341834427.3462.42.camel@twins>
Subject: Re: [PATCH] sched: Use task_rq_unlock on __sched_setscheduler
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Mon, 09 Jul 2012 13:47:07 +0200
In-Reply-To: <1341647342-6742-1-git-send-email-namhyung@kernel.org>
References: <1341647342-6742-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-07 at 16:49 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It seems there's no specific reason to open-code it.  I guess the
> commit 0122ec5b02f76 ("sched: Add p->pi_lock to task_rq_lock()")
> simply missed it.  Let's be consistent with others.

Looks that way, thanks!

