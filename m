Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1HWXTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:19:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44650 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1HWXTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:19:37 -0400
MIME-Version: 1.0
Date: Tue, 23 Aug 2011 19:19:35 -0400
Message-ID: <CAFWT=833UrQ0irJfL5z=6R97+wd4ewW9Cd88maeXhZ_95aMhsw@mail.gmail.com>
Subject: Bug Report for Linux Kernel 3.x
From: Steevven1 <steevven1@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I would like to report what myself and several others believe to be a
serious bug affecting all Linux kernels 3.0 and up, and none below 3.0
(2.6.x and lower).

One-sentence description: On certain hardware, the 3.x series kernels
drain a considerable amount more power than the 2.6-series kernels, up
to 40% more, even when idle.

The specific hardware I have personally tested is a Lenovo ThinkPad
X220 with an Intel SandyBridge i7 2620M processor. We think that this
bug is POSSIBLY specific to this processor, or family of processors,
commonly used in notebooks. A complete thread of mine and others'
results, evidence, and troubleshooting process is located at:
http://ubuntuforums.org/showthread.php?t=1822629

We have tried several different 3.0 and 3.1-series kernels, all with
the same problems. One part of the problem was that the following
(revealed by powertop) was causing excessive processor wakeups
compared to the 2.6-series kernels: "[Rescheduling interrupts] <kernel
IPI>"

Someone much more advanced than I figured out how to eliminate this
problem and recompiled the kernel (which he posted in the thread I
linked to previously), but power usage is still improved only
slightly, nowhere near kernel 2.6 levels.

There is a lot more information I could give you here, but all of it
is contained within the thread I linked to. If you have any specific
questions, I will answer as quickly as possible.

Thanks a lot for your assistance. Please confirm that you received this email.

Steven Keys!
