Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab2GMF4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:56:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40649 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2GMF4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:56:42 -0400
Date: Fri, 13 Jul 2012 07:56:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/8] time: Refactor accumulation of nsecs to secs
Message-ID: <20120713055637.GA18065@gmail.com>
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
 <1342156917-25092-6-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342156917-25092-6-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> We do the exact same logic moving nsecs to secs in the
> timekeeper in multiple places, so condense this into a
> single function.
> 
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Richard Cochran <richardcochran@gmail.com>
> CC: Prarit Bhargava <prarit@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>

Please make that Cc:, not CC:.

Thanks,

	Ingo
