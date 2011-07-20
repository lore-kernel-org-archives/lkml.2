Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1GTXcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 19:32:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36239 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1GTXcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 19:32:22 -0400
MIME-Version: 1.0
Date: Wed, 20 Jul 2011 18:32:21 -0500
Message-ID: <CAO9HMNEk50bU4ytmFtBNEvdEJSf2Oy9kVZqAs1Ln4iiL5yfpbw@mail.gmail.com>
Subject: How does group scheduling interact with sched_batch, sched_idle, etc?
From: Steve Bergman <sbergman27@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I normally run einstein@home under BOINC at a nice level of 19 with
sched_batch. I like the longer timeslices of sched_batch from the
standpoint of L2 cache efficiency. I've now turned
sched_autogroup_enable on, and set the autogroup to nice 19. The BOINC
startup script sets the individual boinc application processes to nice
19 and sched_batch. I'm trying to understand what things I've actually
changed. Do I still have the longer timeslices of sched_batch, along
with the guarantee that they will never be treated as interactive? How
do the autogroup nice level, the individual process nice level, and
the sched_normal, sched_idleprio, and sched_normal parameters all play
together?

Also, I'm wondering what the impact of the group scheduling overhead
might be in the most common case, where I'm not using the machine, and
it's mainly just the 4 boinc processes, all in the same cgroup, using
the processor.

I'm running 2.6.38 x86_64.

Thanks for any information,
Steve Bergman
