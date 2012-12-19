Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab2LSJk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 04:40:26 -0500
Received: from service87.mimecast.com ([91.220.42.44]:59465 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab2LSJkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 04:40:22 -0500
Date: Wed, 19 Dec 2012 09:40:19 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: Re: [RFC PATCH 1/5] ARM: remove useless guard in smp.c
Message-ID: <20121219094019.GC32484@e106331-lin.cambridge.arm.com>
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
 <1355832418-31692-2-git-send-email-mark.rutland@arm.com>
 <50D0BA2D.2020600@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <50D0BA2D.2020600@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 19 Dec 2012 09:40:20.0160 (UTC) FILETIME=[DC3C0400:01CDDDCC]
X-MC-Unique: 112121909402007501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 06:47:09PM +0000, Stephen Boyd wrote:
> On 12/18/12 04:06, Mark Rutland wrote:
> > Currently we only provide an implementation of smp_timer_broadcast in
> > smp.c if GENERIC_CLOCKEVENTS_BROADCAST is selected. As
> > smp_timer_broadcast is only used in smp.c, smp.c depends on SMP, and
> > GENERIC_CLOCKEVENTS_BROADCAST is selected by SMP, this is unnecessary.
> 
> You might want to add that GENERIC_CLOCKEVENTS_BROADCAST depends on
> GENERIC_CLOCKEVENTS and SMP depends on GENERIC_CLOCKEVENTS too.

Will do.

> > This patch removes the redundant guard.
> >
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks!

Mark.

