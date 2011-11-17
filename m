Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab1KQOPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 09:15:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:36728 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab1KQOPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 09:15:18 -0500
Date: Thu, 17 Nov 2011 15:15:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tim Sander <tim.sander@hbm.com>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RT Throtteling with PREEMT-RT on UBIFS root fs update
In-Reply-To: <201111171454.18742.tim.sander@hbm.com>
Message-ID: <alpine.LFD.2.02.1111171511260.4902@ionos>
References: <201111111056.53803.tim.sander@hbm.com> <201111171454.18742.tim.sander@hbm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, Tim Sander wrote:
> Well it can be said that it is not ksoftirqd/0 going berserk which is 
> triggering this. So i guess when this message is printed it just shows that 
> the cpu had been temporarily overloded with work in interrupt context.
> Is there more harm to expect from this message or save to ignore if the 
> systemload is normal again?

There is no harm, this message is informative and if that behaviour is
directly related to an ubifs update then I'd say we should not worry
too much about it. Though it'd be interesting to poke the UBIFS folks
about it.

Thanks,

	tglx
