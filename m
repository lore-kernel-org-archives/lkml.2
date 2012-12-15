Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2LOLRd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 06:17:33 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34633 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab2LOLRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 06:17:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, cpufreq <cpufreq@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq_stats: fix race between stats allocation and first usage
Date: Sat, 15 Dec 2012 12:22:38 +0100
Message-ID: <2504655.pJNUDF76QM@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50CC205D.4040106@openvz.org>
References: <20121214105921.5139.502.stgit@zurg> <4367394.4dMqb5NnJH@vostro.rjw.lan> <50CC205D.4040106@openvz.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 15, 2012 11:01:49 AM Konstantin Khlebnikov wrote:
> Rafael J. Wysocki wrote:
> > On Friday, December 14, 2012 02:59:21 PM Konstantin Khlebnikov wrote:
> >> This patch forces complete struct cpufreq_stats allocation for all cpus before
> >> registering CPUFREQ_TRANSITION_NOTIFIER notifier, otherwise in some conditions
> >> cpufreq_stat_notifier_trans() can be called in the middle of stats allocation,
> >> in this case cpufreq_stats_table already exists, but stat->freq_table is NULL.
> >
> > I'll queue it up for submission as v3.8 material.
> >
> > Does it need to be marked as -stable material too?
> 
> It's very old and rare bug. I think you can leave it as is.

OK

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
