Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab1ESJda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:33:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:58221 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab1ESJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:33:27 -0400
Date: Thu, 19 May 2011 11:33:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [patch 5/7] clockevents: Provide interface to reconfigure an
 active clock event device
In-Reply-To: <20110519091024.GB6251@elte.hu>
Message-ID: <alpine.LFD.2.02.1105191132260.3078@ionos>
References: <20110518205713.947614271@linutronix.de> <20110518210136.437459958@linutronix.de> <20110519091024.GB6251@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011, Ingo Molnar wrote:
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> > + */
> > +int clockevents_reconfigure(struct clock_event_device *dev, u32 freq)
> 
> This too could use a struct clockevents_params perhaps - and would only use 
> params.freq for now but might be extended in the future.
> 
> But i'm fine with this API as well:

I agree for the config_register interface, but here we really just
want to update the frequency and not change any other parameter.
 
Thanks,

	tglx
