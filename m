Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0DSP3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:29:45 -0400
Received: from mx4.sophos.com ([74.202.89.161]:33469 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab0DSP3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:29:43 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand during disk IO
Date: Mon, 19 Apr 2010 16:29:39 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "davej@redhat.com" <davej@redhat.com>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
References: <20100418115949.7b743898@infradead.org> <201004191009.56859.tvrtko.ursulin@sophos.com> <20100419064617.519eb384@infradead.org>
In-Reply-To: <20100419064617.519eb384@infradead.org>
MIME-Version: 1.0
Message-ID: <201004191629.39339.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 19/04/2010 16:29:39,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 19/04/2010 16:29:40,
	Serialize complete at 19/04/2010 16:29:40
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 Apr 2010 14:46:17 Arjan van de Ven wrote:
> On Mon, 19 Apr 2010 10:09:55 +0100
> > Or in other words, does a pure IO workload benefit from now higher
> > selected frequency?
>
> no.
> Mixed workloads do.
> but pure IO workloads also don't suffer since while idle, the voltage
> goes down anyway.

You mean that higher frequency does not have effect on power use if CPU is
idle? Is that true for all/most processors?

> > One idea I had but a) never had time to implement it and b) was not
> > sure it would be accepted anyway, was to modify ondemand governor to
> > ramp up instantly, but slow down slowly (in a configurable way).
>
> that's what ondemand does already.

How and where in the code and how to enable that behaviour? From my
experiments frequency goes down to minimum as soon as load goes away. What I
was talking about is gradual lowering over a configurable period. It is not
power efficient, but it could be good for latency in some workloads.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
