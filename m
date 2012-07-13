Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030784Ab2GMGAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 02:00:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60011 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030201Ab2GMGAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 02:00:40 -0400
Date: Fri, 13 Jul 2012 08:00:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/8] time: Condense timekeeper.xtime into xtime_sec
Message-ID: <20120713060035.GC18065@gmail.com>
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
 <1342156917-25092-5-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342156917-25092-5-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> +static void tk_set_xtime(struct timekeeper *tk, const struct timespec *ts)
> +{
> +	tk->xtime_sec = ts->tv_sec;
> +	tk->xtime_nsec = ts->tv_nsec << tk->shift;
> +}
> +
> +
> +static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)

Small nit: there's a stray newline here.

> +{
> +	tk->xtime_sec += ts->tv_sec;
> +	tk->xtime_nsec += ts->tv_nsec << tk->shift;
> +}
> +
>  
>  /**

Ditto.

Thanks,

	Ingo
