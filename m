Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab0KQLhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:37:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35475 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962Ab0KQLht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:37:49 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, Andre@firstfloor.org,
        ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] New tools: lttngtrace and lttngreport
References: <20101115134243.GA2772@Krystal> <20101115160745.GA7203@Krystal>
Date: Wed, 17 Nov 2010 12:37:48 +0100
In-Reply-To: <20101115160745.GA7203@Krystal> (Mathieu Desnoyers's message of
	"Mon, 15 Nov 2010 11:07:45 -0500")
Message-ID: <87y68sqiyb.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
>
>         --> Blocked in RUNNING, SYSCALL 142 [sys_select+0x0/0xc0], ([...], dur: 0.029567)
>         |    --> Blocked in RUNNING, SYSCALL 168 [sys_poll+0x0/0xc0], ([...], dur: 1.187935)
>         |    --- Woken up by an IRQ: IRQ 0 [timer]
>         --- Woken up in context of 7401 [gnome-power-man] in high-level state RUNNING

Very nice! Now how can we get that with an unpatched kernel tree?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
