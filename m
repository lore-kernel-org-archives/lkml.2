Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab1J0PJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:09:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56817 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab1J0PJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:09:09 -0400
MIME-Version: 1.0
Date: Thu, 27 Oct 2011 16:09:06 +0100
Message-ID: <CAOSRKdSTiLRiwusJEmvudzuLYc+AkYYTka3+AQEpjcb81YtE0w@mail.gmail.com>
Subject: How to choose a default sched policy
From: Sebastiano Spicuglia <spicuglia.sebastiano@gmail.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        peterz <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I implemented, just for accademic purposes, a new sched
policy. Now I need to substitute it to the fair one, so when the kernel
runs, normal tasks are scheduled by mine policy.
How can i perform this switch? Is there in sched.c a single
point of switch or I have to change every occurance of
"p->sched_class = &fair_sched_class;" with
"p->sched_class = &mine_sched_class;"?

Thanks in advance.
Best regards.
Sebastiano
