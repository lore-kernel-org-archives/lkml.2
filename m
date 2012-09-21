Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2IUOp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:45:27 -0400
Received: from forward20.mail.yandex.net ([95.108.253.145]:54077 "EHLO
	forward20.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab2IUOpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:45:25 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Sep 2012 10:45:25 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1348237967.13080.74.camel@gandalf.local.home>
References: <668281348234555@web30d.yandex.ru>
	 <742911348237311@web12h.yandex.ru> <1348237967.13080.74.camel@gandalf.local.home>
Subject: Re: [PATCH]sched/rt.c: leaf_rt_rq_list contains empty queues. Fix it
MIME-Version: 1.0
Message-Id: <211281348238382@web9g.yandex.ru>
Date: Fri, 21 Sep 2012 18:39:42 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Again, the rt_nr_running hasn't been incremented yet. This patch will
> add it when the rq gets a second task.
>
> -- Steve

Right, thanks for the explanation

Kirill
