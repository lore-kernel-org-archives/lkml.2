Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab2KWR2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 12:28:07 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:58199 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2KWR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 12:28:06 -0500
MIME-Version: 1.0
In-Reply-To: <20121123172337.GD24119@mail.gnudd.com>
References: <1353683310-23654-1-git-send-email-ciminaghi@gnudd.com>
	<1353683310-23654-2-git-send-email-ciminaghi@gnudd.com>
	<CAOh2x=ncwZNQDKvFia_yrCmmDJ1Kkk+wP4fhcdeo_YtE97ridA@mail.gmail.com>
	<20121123172337.GD24119@mail.gnudd.com>
Date: Fri, 23 Nov 2012 22:58:04 +0530
Message-ID: <CAKohpokUHv96wutU1ZLxxnndR3wfTr3kjh3UKREtuiVV-V8+EA@mail.gmail.com>
Subject: Re: [PATCH 1/8] DMA: PL330: use prefix in reg names to build under x86
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 November 2012 22:53, Davide Ciminaghi <ciminaghi@gnudd.com> wrote:
> I tried that, but the resulting patch does not apply:

It will not. Git doesn't support it.

> $ git checkout -b pl330_test next-20121115
> Switched to a new branch 'pl330_test'
>
> $ git format-patch --word-diff 5f1e3c5~..5f1e3c5

I never asked you to do this. I asked you to use git diff command, just to
verify what you have done is right or not? You can't send output of that
as a patch :)

And maybe post that as an part of non-commit log, so that others can
quickly review it. But because your patch is too big, it will make it a huge
patch.

It was just an trick i was sharing with everybody else.

> Did I do anything wrong (sorry, I'm not a git guru at all) ?

Neither am i :)

--
viresh
