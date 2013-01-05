Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3AEVsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 16:48:00 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:32937 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851Ab3AEVr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 16:47:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Woody Suwalski <terraluna977@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: 3.8-rc[12] cpufreq build errors...
Date: Sat, 05 Jan 2013 22:53:35 +0100
Message-ID: <2446683.GzoeULsVfp@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <50E83B2D.9000609@gmail.com>
References: <50E83B2D.9000609@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 05, 2013 09:39:41 AM Woody Suwalski wrote:
> Rafael, in 3.8 kernel part of the common logic has been moved to a 
> separate cpufreq_governor.c file.
> According to the Makefile, the cpufreq_governor.o is to be linked to 
> other cpufreq  modules.
> 
> However I see that a separate malformed cpufreq_governor.ko is created, 
> and then the real modules can not work without the common logic either.
> 
> The build config is a simple 32-bit config, on top of vanilla source.
> 
> I submit a verbose build log with "ls *.ko" and some "modinfo" outputs 
> attached to the bottom.
> Clearly the build subsystem is misinterpreting the build intentions.
> 
> Could you please check if you see the same issue in your builds?
> I am using a 32-bit October-ish Debian Testing as a build machine (Eeepc 
> netbook).

This issue has already been reported and there's a fix scheduled for
inclusion in the master branch of the linux-pm.git tree.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
