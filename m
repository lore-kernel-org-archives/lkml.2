Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab2FNNdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:33:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:53289 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2FNNdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:33:15 -0400
Message-Id: <20120614132902.800827488@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jun 2012 15:29:02 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, pjt@google.com, venki@google.com, efault@gmx.de,
        rostedt@goodmis.org, glommer@parallels.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/4] sched: Optimize cgroup muck
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I finally got some time to make this stuff work (it boots!).

I haven't actually done any benchmarks etc.. but various people expressed
interest in the fold put_prev_task into pick_next_task thing.

Please give it a spin or so..

