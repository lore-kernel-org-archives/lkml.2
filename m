Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2IQFzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 01:55:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37904 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2IQFzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 01:55:45 -0400
Date: Sun, 16 Sep 2012 22:53:07 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Colin Cross <ccross@android.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH/RFC 0/4] Deferrable timers support for timerfd API
Message-ID: <20120917055306.GA29081@lizard>
References: <20120902054335.GA12741@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120902054335.GA12741@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Sat, Sep 01, 2012 at 10:43:35PM -0700, Anton Vorontsov wrote:
> This patch set implements a userland-side API for generic deferrable
> timers, per linux/timer.h:
> 
>  * A deferrable timer will work normally when the system is busy, but
>  * will not cause a CPU to come out of idle just to service it; instead,
>  * the timer will be serviced when the CPU eventually wakes up with a
>  * subsequent non-deferrable timer.
> 
> These timers are crucial for power saving, i.e. periodic tasks that want
> to work in background when the system is under use, but don't want to
> cause wakeups themselves.

Just a friendly ping. Does anyone had a chance to look into this,
whether the idea bad or good, or whether the implementation is OK?

Thanks!

Anton.
