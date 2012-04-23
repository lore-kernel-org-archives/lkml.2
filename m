Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab2DWJJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:09:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41628 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2DWJJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:09:31 -0400
MIME-Version: 1.0
Date: Mon, 23 Apr 2012 17:09:30 +0800
Message-ID: <CANQmPXh-cu9tOJfceNZRHCBKFwR1-D5gQJOdMsnjty_LeLAADw@mail.gmail.com>
Subject: [PATCH] RIFS cpu scheduler
From: mou Chen <hi3766691@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here s the link of the cpu scheduler.
http://code.google.com/p/rifs-scheduler/downloads/list

Patch the kernel firsrt, then replace the file /kernel/sched/rifs.c
with the new one that I attached.

It is designed for interactivity and responsiveness. :-)

You can just test the scheduler about the interactivity by compiling
your kernel with -j32 or above, then listen to music and browse
webpage by Firefox.

Have fun.
