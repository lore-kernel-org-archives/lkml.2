Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168Ab2FGBgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 21:36:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56793 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2FGBgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 21:36:46 -0400
MIME-Version: 1.0
In-Reply-To: <1339025388.28766.70.camel@sbsiddha-desk.sc.intel.com>
References: <20120509093001.GD8585@gmail.com>
	<1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
	<1336589196-14498-2-git-send-email-suresh.b.siddha@intel.com>
	<1336593505.4634.11.camel@sbsiddha-desk.sc.intel.com>
	<20120510075031.GC28395@gmail.com>
	<1339025388.28766.70.camel@sbsiddha-desk.sc.intel.com>
Date: Wed, 6 Jun 2012 18:36:45 -0700
X-Google-Sender-Auth: L5dyR_18FO2qPFmLN-Ul6fHxGkQ
Message-ID: <CAE9FiQXh82++LRJnFbYXAVQmCPM00M8HO0KQ523WYD+rZKvt2w@mail.gmail.com>
Subject: Re: [patch] irq: use config_enabled(SMP) checks to cleanup
 irq_set_affinity() for UP
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        joerg.roedel@amd.com, paul.gortmaker@windriver.com,
        Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 4:29 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> On Ingo's request, re-basing the previous version
> (http://marc.info/?l=linux-kernel&m=133667389223282) to the latest -tip
> tree. Thanks.
> ---
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: irq: use config_enabled(CONFIG_SMP) checks to cleanup irq_set_affinity() for UP
>
> Use config_enabled(CONFIG_SMP) checks for cleaning up the ifdef CONFIG_SMP
> around irq_set_affinity routines in io_apic and irq_remapping subsystems.

can you just use
if (nr_cpu_ids > 1)
checking instead
if config_enabled(CONFIG_SMP)

Thanks

Yinghai Lu
