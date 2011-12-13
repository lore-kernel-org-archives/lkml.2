Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1LMPtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:49:43 -0500
Received: from mail.lippert-at.com ([62.80.22.186]:57334 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753720Ab1LMPtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:49:41 -0500
Message-ID: <4EE77416.8090907@LiPPERTEmbedded.de>
Date: Tue, 13 Dec 2011 16:49:42 +0100
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: Re: IRQF_TIMER | IRQF_SHARED ?
References: <4EE620A5.7080402@LiPPERTEmbedded.de> <20111212123131.502be350@queued.net>
In-Reply-To: <20111212123131.502be350@queued.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Dec 2011 15:49:37.0223 (UTC) FILETIME=[D1348570:01CCB9AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Salomon schrieb:
> Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:
>> and it seemed to work (well, at least audio worked, don't know how to
>> explicitly test cs5535-clockevt).
> Just loading cs5535-clockevt should start the periodic timer.  On my
> XO-1, IRQ 7 starts firing immediately.

Hmm, no, doesn't work. :-|  In /proc/interrupts IRQ0 gets increased, not (in
my case) IRQ 11. And also in /proc/timer_list next_event gets increased for
the pit device, not cs5535-clockevt.

But that's even without sharing enabled ... I guess I'll have to figure out
first what's going wrong here and then re-test. I'll get back to you ...

Thanks and regards,
Jens

