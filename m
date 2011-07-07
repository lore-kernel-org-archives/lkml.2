Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1GGRFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:05:17 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:35085 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754444Ab1GGRFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:05:15 -0400
From: Kevin Hilman <khilman@ti.com>
To: Todd Poynor <toddpoynor@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@android.com>
Subject: Re: [PATCH 0/3] Add generic idle notifiers
Organization: Texas Instruments, Inc.
References: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
Date: Thu, 07 Jul 2011 10:05:10 -0700
In-Reply-To: <1309229190-25006-1-git-send-email-toddpoynor@google.com> (Todd
	Poynor's message of "Mon, 27 Jun 2011 19:46:27 -0700")
Message-ID: <87ei22dnsp.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todd Poynor <toddpoynor@google.com> writes:

> Add notifiers for idle entry and exit, called with IDLE_START when a
> CPU goes idle and IDLE_END when it goes out of idle, based on the
> existing idle notifiers for the x86_64 arch.
>
> Convert x86_64 to use these notifiers, and call the notifiers on ARM.
>
> Convert the ARM LEDs events for idle start/end to these notifiers.

Is this intended to replace the more general CPU PM notifiers proposed
by Colin:

http://lists.infradead.org/pipermail/linux-arm-kernel/2011-June/052827.html

Kevin
