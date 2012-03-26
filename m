Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab2CZRNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:13:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933067Ab2CZRNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:13:44 -0400
Date: Mon, 26 Mar 2012 19:04:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org
Subject: Re: [PATCH v2.1 01/10] cpu: Introduce clear_tasks_mm_cpumask()
	helper
Message-ID: <20120326170443.GA25229@redhat.com>
References: <20120324102609.GA28356@lizard> <20120324102751.GA29067@lizard> <1332593021.16159.27.camel@twins> <20120324164316.GB3640@lizard> <20120325174210.GA23605@redhat.com> <1332748746.16159.62.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332748746.16159.62.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Peter Zijlstra wrote:
>
> On Sun, 2012-03-25 at 19:42 +0200, Oleg Nesterov wrote:
> > __cpu_disable() is called by __stop_machine(), we know that nobody
> > can preempt us and other CPUs can do nothing.
>
> It would be very good to not rely on that though,

Yes, yes, perhaps I wasn't clear but I think the patches are fine.

> I would love to get
> rid of the stop_machine usage in cpu hotplug some day.

Interesting... Why? I mean, why do you dislike stop_machine() in
_cpu_down() ? Just curious.

Oleg.

