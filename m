Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab0FIJVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:21:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41429 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454Ab0FIJVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:21:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sedat.dilek@gmail.com
Subject: Re: 2.6.35-rc2-git2: Reported regressions from 2.6.34
Date: Wed, 9 Jun 2010 11:22:35 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>, dmonakhov@openvz.org
References: <Rlf_Qjov7bG.A.a8F.I8rDMB@chimera> <AANLkTiksbL1qHg7Q0A-6TbX0uUrxra4jctUoIGVk5vnE@mail.gmail.com>
In-Reply-To: <AANLkTiksbL1qHg7Q0A-6TbX0uUrxra4jctUoIGVk5vnE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006091122.35304.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 June 2010, Sedat Dilek wrote:
> The patch from [1] is still missing.
> 
>    "cpufreq-call-nr_iowait_cpu-with-disabled-preemption.patch" from
> Dmitry Monakhoc
> 
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>
> 
> I have already reported this issue on LKML [2] and cpufreq ML [3].
> 
> - Sedat -
> 
> [1] http://www.spinics.net/lists/cpufreq/msg01631.html
> [2] http://lkml.org/lkml/2010/5/31/77
> [3] http://www.spinics.net/lists/cpufreq/msg01637.html

Thanks, added.

Rafael
