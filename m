Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab2FEIBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 04:01:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35948 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab2FEIBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 04:01:46 -0400
MIME-Version: 1.0
In-Reply-To: <4FCDBC8E.1000705@kernel.org>
References: <CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com>
	<CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com>
	<CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com>
	<CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
	<CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com>
	<20120601122118.GA6128@lizard>
	<alpine.LFD.2.02.1206032125320.1943@tux.localdomain>
	<4FCC7592.9030403@kernel.org>
	<20120604113811.GA4291@lizard>
	<20120604121722.GA2768@barrios>
	<20120604133527.GA13650@lizard>
	<CAOJsxLHkzubReaR0utB4xdage0Omb4r=jhXCLwXQ8XOSct4LGg@mail.gmail.com>
	<4FCDBC8E.1000705@kernel.org>
Date: Tue, 5 Jun 2012 11:01:45 +0300
X-Google-Sender-Auth: HjfD5ROV4vTVzPe9CyBWQmy_Xxc
Message-ID: <CAOJsxLHOdnQKSfLqFG4hdabhuwhHt+HqKGerP23YuNQc4TZS_g@mail.gmail.com>
Subject: Re: [PATCH 0/5] Some vmevent fixes...
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 11:00 AM, Minchan Kim <minchan@kernel.org> wrote:
>> That's what Nokia's lowmem notifier uses. We can probably drop them
>> once we have something else they could use.
>
> Next concern is that periodic timer of implementation.
> I think it would add direct hook in vmscan.c rather than peeking raw vmstat periodically by timer
> so we can control more fine-grained way without unnecessary overhead.

If the hooks are clean and it doesn't hurt the  !CONFIG_VMEVENT case,
I'm completely OK with that.
