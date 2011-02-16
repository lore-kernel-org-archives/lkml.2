Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1BPST7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 13:19:59 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53074 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1BPST4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 13:19:56 -0500
Subject: Re: [PATCH 3/5] time: Extend get_xtime_and_monotonic_offset() to
 also return sleep
From: John Stultz <john.stultz@linaro.org>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        Arve =?ISO-8859-1?Q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
In-Reply-To: <4D5BDB31.4090304@fastmail.fm>
References: <1297830007-426-1-git-send-email-john.stultz@linaro.org>
	 <1297830007-426-4-git-send-email-john.stultz@linaro.org>
	 <4D5BDB31.4090304@fastmail.fm>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 10:19:49 -0800
Message-ID: <1297880389.2581.46.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 14:12 +0000, Jack Stone wrote:
> On 16/02/2011 04:20, John Stultz wrote:
> > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> > index 5fbd9aa..29f75aa 100644
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> > @@ -1043,8 +1043,10 @@ void do_timer(unsigned long ticks)
> >   * get_xtime_and_monotonic_offset() - get xtime and wall_to_monotonic
> 
> Can you update the function name in the comment as well.

Thanks for catching that!  Will do!
-john

