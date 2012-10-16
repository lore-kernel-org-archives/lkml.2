Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab2JPRvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:51:33 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62549 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2JPRvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:51:32 -0400
MIME-Version: 1.0
Date: Tue, 16 Oct 2012 12:51:31 -0500
Message-ID: <CAMjP1K=WV=AJ=paz7uBJ2X0FnOX6Cf-HipWsFjLxicXGbvL6Sw@mail.gmail.com>
Subject: Reading /proc/slabinfo causes stalls
From: Avleen Vig <avleen@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I *think* this is the right place to ask this, and apologies if it's not
(is there a better place?).

We have checks which read /proc/slabinfo once a minute, and have noticed
that this causes the entire system to stall for a few milliseconds.
It's long enough that it causes noticeable delays in latency-sensitive
applications (between 10ms and 100ms).

Is this a known condition? Are there work arounds or other ways to get the
slab allocation data which don't cause stalls?


Thanks :-)
