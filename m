Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0KWLfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 06:35:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:48636 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0KWLfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 06:35:44 -0500
Subject: Re: [PATCH 3/5] scheduler: cpuacct: Enable platform hooks to track
 cpuusage for CPU frequencies
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Chan <mike@android.com>
Cc: Florian Mickler <florian@mickler.org>,
        John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <AANLkTike-bR-fjakyxiFbWvER=BYdDnFSegjOcdsb1qt@mail.gmail.com>
References: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
	 <1290218934-8544-4-git-send-email-john.stultz@linaro.org>
	 <1290250104.2118.4.camel@laptop> <20101122065129.072bba06@schatten.dmk.lab>
	 <1290422639.2110.3.camel@laptop> <20101122132306.245e0bcb@schatten.dmk.lab>
	 <AANLkTike-bR-fjakyxiFbWvER=BYdDnFSegjOcdsb1qt@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 12:35:59 +0100
Message-ID: <1290512159.2072.392.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 18:05 -0800, Mike Chan wrote:

> This is useful for tracking cpu power per c-group. We split each
> android application into its own c-group and track what cpu speeds and
> how long the cpu spent for each one. Peter we've actually discussed
> this before:
> http://lkml.org/lkml/2010/5/6/301
> 
> These patches were discussed with Paul Menage and Balbir Singh back in
> April, as well as on lmkl and the cpufreq mailing lists. These may or
> may not be useful for mainline, I assume anyone wanting to track power
> specific for c-groups would be interested. I'm open for different
> implementations that can help achieve cpu power tracking per-cgroup if
> this particular implementation is controversial, or if you just want
> to help make Android's kernel better.

Right, so Stephane is working on perf-cgroup bits (I saw he recently
posted another version, which I guess I ought to look at soonish).

With that it would be rather simple to use perf to track per-cgroup
power state.
