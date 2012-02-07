Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2BGOgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:36:18 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36497 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2BGOgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:36:17 -0500
Message-ID: <1328625373.3443.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH v2] perf: fix assertion failure in x86_pmu_start()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        markus@trippelsdorf.de, paulus@samba.org
Date: Tue, 07 Feb 2012 15:36:13 +0100
In-Reply-To: <20120207133956.GA4932@quad>
References: <20120207133956.GA4932@quad>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 07 février 2012 à 14:39 +0100, Stephane Eranian a écrit :
> The following patch fixes an issue introduced by the following
> commit:
>         e050e3f0a71b ("perf: Fix broken interrupt rate throttling")
> 
> The patch caused the following warning to pop up depending on
> the sampling frequency adjustments:
> 
...

> 
> In this second version, we've added calls to disable/enable PMU during
> unthrottling or frequency adjustment based on bug report of spurious
> NMI interrupts from Eric Dumazet.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---

I tested successfully this patch on my two dev machines, thanks for
fixing this Stephane.

Reported-and-tested-by: Eric Dumazet <eric.dumazet@gmail.com>



