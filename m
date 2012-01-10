Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2AJE53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 23:57:29 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60792 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab2AJE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 23:57:28 -0500
Message-ID: <1326171444.6638.3.camel@edumazet-laptop>
Subject: [BUG] kernel freezes with latest tree
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jan 2012 05:57:24 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

I got some freezes on two different machines, using latest kernel.

while :; do hackbench 10 thread 4000; done

Not sure I'll have time today to find the problem.

It might be related to "perf top" also being run at least once.


