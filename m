Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab1HJNHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:07:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab1HJNHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:07:17 -0400
Date: Wed, 10 Aug 2011 09:06:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        Ingo Molnar <mingo@elte.hu>, Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>
Subject: Re: [PATCH v5 2/2] Output stall data in debugfs
Message-ID: <20110810130652.GI1972@redhat.com>
References: <1312935763-23570-1-git-send-email-zakmagnus@chromium.org>
 <1312935763-23570-2-git-send-email-zakmagnus@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312935763-23570-2-git-send-email-zakmagnus@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 05:22:43PM -0700, Alex Neronskiy wrote:
> From: Alex Neronskiy <zakmagnus@chromium.com>
> 
> Instead of using the log, use debugfs for output of both stall
> lengths and stack traces. Printing to the log can result in
> watchdog touches, distorting the very events being measured.
> Additionally, the information will not distract from lockups
> when users view the log.
> 
> A two-buffer system is used to ensure that the trace information
> can always be recorded without contention.

This looks like it can work.  I'll try to play with it today.  Can I ask
that you add some comments to document the way the buffers work, so others
know what is going on to.

Cheers,
Don
