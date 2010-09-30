Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0I3H7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 03:59:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49633 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab0I3H7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 03:59:42 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Proper kernel irq time accounting -v3
References: <1285788096-29471-1-git-send-email-venki@google.com>
Date: Thu, 30 Sep 2010 09:59:40 +0200
In-Reply-To: <1285788096-29471-1-git-send-email-venki@google.com> (Venkatesh
	Pallipadi's message of "Wed, 29 Sep 2010 12:21:29 -0700")
Message-ID: <8762xnwtjn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venkatesh Pallipadi <venki@google.com> writes:
>
> Solution to (1) involves adding extra timing on irq entry/exit to
> get the fine granularity info and then exporting it to user.

This means RDTSC right?

I am a bit concerned about overhead on systems with high TSC overhead.
Is there a way to turn this off at runtime for those?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
