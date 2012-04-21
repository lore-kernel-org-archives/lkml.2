Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2DUGwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 02:52:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33564 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2DUGwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 02:52:17 -0400
MIME-Version: 1.0
Date: Sat, 21 Apr 2012 14:52:16 +0800
Message-ID: <CAEffOLK9Vs36chTs9mjzYTdVJuCJOB+Uc4u6-4Ux8oTLTNGB8Q@mail.gmail.com>
Subject: A question from a beginner: why not record TIF_NEED_RESCHED flag for
 each CPU rather than for each thread?
From: Yongle Zhang <linux.kevinzyl@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone~,

I'm a student, and a beginner learning linux. And when I'm reading the
kernel source code I got a question.
I discussed it with some friends and posed it on the internet, but
didn't get a clear answer. And they recommended me to ask for help
directly from the developers~
Wish this won't bother you!

The question is as below:

In linux kernel 2.6.11, the TIF_NEED_RESCHED flag is recorded in
thread_info struct for each task.

I searched the kernel and found that, it can only be set by the
current thread on the CPU for itself. So why not put the
TIF_NEED_RESCHED in some per CPU structure instead of in each
thread_info?

If this flag is only used to show that current thread on this cpu
needs schedule(), then I think perhaps it is OK to record it for each
CPU rather than for each thread?

If both of the methods are logically OK, then why is the flag recorded
in thread_info? Is it because of some performance issue, or some
historical reason?

Thanks for your attention and time~!
Best regards,

Kevin Zhang
