Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab2AKRWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:22:32 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65330 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab2AKRWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:22:30 -0500
MIME-Version: 1.0
Date: Wed, 11 Jan 2012 23:22:29 +0600
Message-ID: <CADZ9YHicin2YjGm_m9B0LMv3NW1Z3cb7HSCaqwycFmVfRpvpWA@mail.gmail.com>
Subject: [Question] sched: Should nr_uninterruptible be decremented in ttwu_do_activate()?
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

In ttwu_do_activate(), we're decrementing nr_uninterruptible if
p->sched_contributes_to_load (for SMP=y). But, we're also decrementing
nr_uninterruptible from activate_task at the same path. Why we're
doing it twice for a single task activation path?


Thanks,
Rakib
