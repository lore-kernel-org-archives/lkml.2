Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1KTBzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 20:55:17 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35981 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1KTBzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 20:55:16 -0500
From: Edward Donovan <edward.donovan@numble.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, maciej.rutecki@gmail.com
Subject: [PATCH] genirq: fix second 2.6.39 regression in irqfixup, irqpoll
Date: Sat, 19 Nov 2011 20:54:22 -0500
Message-Id: <1321754063-2887-1-git-send-email-edward.donovan@numble.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas -

I did isolate another regression in the bad-irq handling, and this
patch sets things right on my machines.  After bisecting it, I've just
been troubleshooting to find which code was making the difference.
This is my attempt to restore it, in a reasonable place.

I don't know if this is the way you'd like to do it in the reworked
IRQ code, since I'm not very familiar with the system yet.  This is
the most C I've dealt with, and partly I'm just moving puzzle pieces
around.  I have tested it a good bit, though, and functionally it has
been fine.

So, let me know if you have a preferred patch, and I'll test it on
these machines.  Thanks!

Edward

