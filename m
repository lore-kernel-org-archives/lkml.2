Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab1JKHQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:16:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43056 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1JKHQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 03:16:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAKfTPtB3sLWq5fHOTrFg6vfHSKnz2i17oYx9Btr0u_tWV2bsjQ@mail.gmail.com>
References: <CAKfTPtB3sLWq5fHOTrFg6vfHSKnz2i17oYx9Btr0u_tWV2bsjQ@mail.gmail.com>
Date: Tue, 11 Oct 2011 12:46:07 +0530
Message-ID: <CAP245DX8b45Nj5SAwtLivp_vMKpwfeUrqnR2sqjnVyqiRd61gg@mail.gmail.com>
Subject: Re: sched: ARM: arch_scale_freq_power
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, LAK <linux-arm-kernel@lists.infradead.org>,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Peter to the discussion..

On Thu, Oct 6, 2011 at 5:06 PM, Vincent Guittot
<vincent.guittot@linaro.org> wrote:
> I work to link the cpu_power of ARM cores to their frequency by using
> arch_scale_freq_power. It's explained in the kernel that cpu_power is
> used to distribute load on cpus and a cpu with more cpu_power will
> pick up more load. The default value is SCHED_POWER_SCALE and I
> increase the value if I want a cpu to have more load than another one.
> Is there an advised range for cpu_power value as well as some time
> scale constraints for updating the cpu_power value ?
> I'm also wondering why this scheduler feature is currently disable by default ?
>
> Regards,
> Vincent

In discussions with Vincent regarding this, I've wondered whether
cpu_power wouldn't be better renamed to cpu_capacity since that is
what it really seems to describe.
