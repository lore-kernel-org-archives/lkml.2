Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2BGLYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:24:51 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51423 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2BGLYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:24:50 -0500
Message-ID: <1328613886.3443.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] perf: fix assertion failure in x86_pmu_start()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, markus@trippelsdorf.de, paulus@samba.org
Date: Tue, 07 Feb 2012 12:24:46 +0100
In-Reply-To: <CABPqkBRwjwG0i+J_Qzgm+khHRD+LiT60vMEQA3w1MtPq-FFKLw@mail.gmail.com>
References: <20120206205354.GA31186@quad>
	 <1328603689.2476.15.camel@edumazet-laptop> <20120207084156.GA15359@elte.hu>
	 <1328610322.2232.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CABPqkBTL70n-e9TZo=QOZDk1J84Ye5wGrm6uz=VNu73nwwxhjw@mail.gmail.com>
	 <1328610997.2232.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CABPqkBRwjwG0i+J_Qzgm+khHRD+LiT60vMEQA3w1MtPq-FFKLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 07 février 2012 à 11:40 +0100, Stephane Eranian a écrit :
> Eric,
> 
> How do you deal with that:
> 
> [    0.019998] Performance Events: PEBS fmt0+, Core2 events, Broken
> BIOS detected, complain to your hardware vendor.
> [    0.019998] [Firmware Bug]: the BIOS has corrupted hw-PMU resources
> (MSR 186 is 43003c)
> 
> Your BIOS is using a counter to count cycles for power savings tricks.
> That is conflicting
> with perf_events.

This was already discussed last year.

https://lkml.org/lkml/2011/3/24/552

Apparently all HP blades I have in my labs have the problem, whatever
option is chosen in BIOS.

On my machines, I set the BIOS to 'High performance', and cpus are on
highest available frequencies.



