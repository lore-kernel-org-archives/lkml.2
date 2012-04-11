Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab2DKPdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:33:35 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:31234 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2DKPde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:33:34 -0400
Message-ID: <1334158410.2226.12.camel@lorien2>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: shuahkhan@gmail.com, akpm@linux-foundation.org, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 11 Apr 2012 09:33:30 -0600
In-Reply-To: <1334138713.10826.134.camel@ted>
References: <1333310039.2879.4.camel@lorien2> <1334064283.10826.6.camel@ted>
	 <1334071916.2287.12.camel@lorien2> <1334138713.10826.134.camel@ted>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 11:05 +0100, Richard Purdie wrote:
> On Tue, 2012-04-10 at 09:31 -0600, Shuah Khan wrote:
> > On Tue, 2012-04-10 at 14:24 +0100, Richard Purdie wrote:

> No, I did not mean adding another interface. Why can't we have a trigger
> which just triggers once and then stops? It would be similar to the
> timer trigger but with a different name and way of operating.

This patch adds code to register a new trigger named timer-no-default
and uses delay_on and delay_off to set the timer once. timer is not set
when delay == LED_TIMER_FOREVER. Are you concerned about overloading
blink_delay_on and blink_delay_off values specifically?

> 
> > > Dimity raises some valid questions about the force-feedback framework in
> > > the input system too. We need to make a decision about where phone
> > > vibration framework belongs and then stick to that. You can argue this
> > > to either subsystem, neither "led" or "input" is a obvious description
> > > of phone vibration at a first glance!
> > 
> > force-feedback framework is another alternative. Making a decision is
> > great, what are the next steps to get closer to making a call? 
> 
> I'd first like to understand why this couldn't be a separate trigger,
> then we can understand the alternatives we're comparing.

Yes. No problem doing that.

-- Shuah
> 
> Cheers,
> 
> Richard
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


