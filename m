Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1AFTma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 14:42:30 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57232 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab1AFTm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 14:42:29 -0500
Message-ID: <4D261B23.5040100@kernel.dk>
Date: Thu, 06 Jan 2011 20:42:27 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Jeff Moyer <jmoyer@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
        Alan.Brunelle@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace event block fix unassigned field
References: <20110106184331.GA2449@Krystal>
In-Reply-To: <20110106184331.GA2449@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-06 19:43, Mathieu Desnoyers wrote:
> The "error" field in block_bio_complete is not assigned, leaving the
> memory area uninitialized (keeping garbage data). Pass an additional
> tracepoint argument to this event to initialize this field.

Thanks guys, applied.


-- 
Jens Axboe

