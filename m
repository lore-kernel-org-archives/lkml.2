Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab0IHNYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:24:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40307 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab0IHNYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:24:03 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Jan Blunck <jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org, peterz@infradead.org,
        Sven-Thorsten Dietrich <sdietrich@novell.com>,
        Michael Galbraith <MGalbraith@novell.com>
Subject: Re: [RFC 1/4] ftrace: Add events for tracing timer interrupts
References: <1283948964-6418-1-git-send-email-jblunck@suse.de>
	<1283948964-6418-2-git-send-email-jblunck@suse.de>
Date: Wed, 08 Sep 2010 15:24:01 +0200
In-Reply-To: <1283948964-6418-2-git-send-email-jblunck@suse.de> (Jan Blunck's
	message of "Wed, 8 Sep 2010 14:29:21 +0200")
Message-ID: <87zkvsweq6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Blunck <jblunck@suse.de> writes:

> Trace the execution of the timer interrupt. I did not find an argument that
> makes any sense so traces look like this:
>
> <idle>-0     [000] 181019.693546: timerirq_enter: unused=1
> <idle>-0     [000] 181019.693553: timerirq_exit: unused=1

I think you can get the same by just filtering the normal
irq entry for the timer irq  number.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
