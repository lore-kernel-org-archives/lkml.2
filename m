Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab2BGIz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 03:55:28 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34387 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab2BGIz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 03:55:27 -0500
Message-ID: <1328604921.2476.16.camel@edumazet-laptop>
Subject: Re: [PATCH] perf: fix assertion failure in x86_pmu_start()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, markus@trippelsdorf.de, paulus@samba.org
Date: Tue, 07 Feb 2012 09:55:21 +0100
In-Reply-To: <20120207084156.GA15359@elte.hu>
References: <20120206205354.GA31186@quad>
	 <1328603689.2476.15.camel@edumazet-laptop> <20120207084156.GA15359@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 07 février 2012 à 09:41 +0100, Ingo Molnar a écrit :

> Were these messages introduced by:
> 
>  e050e3f0a71b: perf: Fix broken interrupt rate throttling
> 
> as well?
> 
> In any case I'm holding off on applying the patch before this is 
> resolved.
> 

I'll try this in a couple of hours, and let you know.

Thanks


