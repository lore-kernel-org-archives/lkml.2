Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab1BBJTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 04:19:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33404 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab1BBJTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 04:19:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GYGax3nuM1CR5QgQpGS32wuzn5Ak5jl6DTTfAFMAV/hrOrg0jHDv/bmsIpRHHtZXNc
         iNnBz9c52CxXR/EFnyQ5u49wvchGWCtneHqJp/kSnIVUd4zuuifJTZsMq/37u1sbywlw
         +XYibSZl2EHc8daK5YmitnrSLfX4ZRavasgXw=
Date: Wed, 2 Feb 2011 10:19:00 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 27/28] posix-timers: Add support for fd based clocks
Message-ID: <20110202091900.GE2747@riccoc20.at.omicron.at>
References: <20110201134320.688829863@linutronix.de>
 <20110201134420.062860200@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201134420.062860200@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 01:52:32PM -0000, Thomas Gleixner wrote:
> --- linux-2.6-tip.orig/include/linux/posix-timers.h
> +++ linux-2.6-tip/include/linux/posix-timers.h

> +/*
> + * Bit fields within a clockid:
> + *
> + * The most significant 29 bits hold either a pid or a file descriptor.
> + *
> + * Bit 2 indicates whether a cpu clock refers to a thread or a process.
> + *
> + * Bits 1 and 0 give the type: PROF=0, VIRT=1, SCHED=2, or FD=3.
> + *
> + * A clockid is invalid if bits 2, 1, and 0 all set.

I should have said, "if bits 2, 1, and 0 *are* all set."

Thanks,
Richard
