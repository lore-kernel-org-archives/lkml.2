Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab1HPPQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:16:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab1HPPQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:16:28 -0400
Date: Tue, 16 Aug 2011 11:16:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        Ingo Molnar <mingo@elte.hu>, Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v7 2/2] Output stall data in debugfs
Message-ID: <20110816151605.GL1972@redhat.com>
References: <1313105708-13331-1-git-send-email-zakmagnus@chromium.org>
 <1313105708-13331-2-git-send-email-zakmagnus@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313105708-13331-2-git-send-email-zakmagnus@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 04:35:08PM -0700, Alex Neronskiy wrote:
> Instead of using the log, use debugfs for output of both stall
> lengths and stack traces. Printing to the log can result in
> watchdog touches, distorting the very events being measured.
> Additionally, the information will not distract from lockups
> when users view the log.
> 
> A two-buffer system is used to ensure that the trace information
> can always be recorded without contention.
> 
> Signed-off-by: Alex Neronskiy <zakmagnus@chromium.org>
> ---
> Changes from last version per Peter's suggestions: different
> locks, refactoring, ACCESS_ONCE.

I think I am going to ignore these patches for now until I see if you can
solve things using Ingo's idea.

Cheers,
Don
