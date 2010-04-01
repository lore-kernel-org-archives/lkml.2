Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0DAJQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:16:33 -0400
Received: from mailout1.uni-giessen.de ([134.176.2.3]:51125 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754740Ab0DAJQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:16:24 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Apr 2010 05:16:24 EDT
From: Marvin <marvin24@gmx.de>
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 4/6] cpufreq: Add APERF/MPERF support for AMD processors
Date: Thu, 1 Apr 2010 11:01:04 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc3; KDE/4.4.2; x86_64; ; )
References: <1270065406-1814-1-git-send-email-bp@amd64.org> <1270065406-1814-5-git-send-email-bp@amd64.org>
In-Reply-To: <1270065406-1814-5-git-send-email-bp@amd64.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011101.04420.marvin24@gmx.de>
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-Envelope-From: marvin24@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Mark Langsdorf <mark.langsdorf@amd.com>
> 
> Starting with model 10 of Family 0x10, AMD processors may have
> support for APERF/MPERF.  Add support for identifying it and using
> it within cpufreq.  Move the APERF/MPERF functions out of the
> acpi-cpufreq code and into their own file so they can easily be
> shared.

just out of interest: what are the realnames of these processors (>= Mangy-Core) ?

> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Reviewed-by: Thomas Renninger <trenn@suse.de>
> ---
>  arch/x86/kernel/cpu/cpufreq/Makefile       |    4 +-
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   44 +-----------------------
>  arch/x86/kernel/cpu/cpufreq/mperf.c        |   50
> ++++++++++++++++++++++++++++ arch/x86/kernel/cpu/cpufreq/mperf.h        | 
>   9 +++++
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |    8 ++++
>  5 files changed, 71 insertions(+), 44 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.c

this file has no copyright or module license, thus tainting my kernel...

>  create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.h
> 

Marvin
