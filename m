Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab2EVMnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:43:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55870 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab2EVMnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:43:52 -0400
MIME-Version: 1.0
Date: Tue, 22 May 2012 20:43:52 +0800
Message-ID: <CAJd=RBAvuH=Uyp+ieg9i80c-mB-9o4EpHQMhi52Zu36rUV5C5g@mail.gmail.com>
Subject: Re: BFS 420: cleanup wake_up_idle_cpu
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should go with CONFIG_NO_HZ, so remove the lost orphan.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Tue May 22 19:56:06 2012
@@ -2813,7 +2813,6 @@ static void task_running_tick(struct rq
 	grq_unlock();
 }

-void wake_up_idle_cpu(int cpu);

 /*
  * This function gets called by the timer code, with HZ frequency.
--
