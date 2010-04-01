Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0DAKgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 06:36:24 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35478 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab0DAKgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:36:17 -0400
Date: Thu, 1 Apr 2010 12:36:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: Marvin <marvin24@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] cpufreq: Add APERF/MPERF support for AMD processors
Message-ID: <20100401103659.GB5893@aftab>
References: <1270065406-1814-1-git-send-email-bp@amd64.org>
 <1270065406-1814-5-git-send-email-bp@amd64.org>
 <201004011101.04420.marvin24@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004011101.04420.marvin24@gmx.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marvin <marvin24@gmx.de>
Date: Thu, Apr 01, 2010 at 11:01:04AM +0200

> > From: Mark Langsdorf <mark.langsdorf@amd.com>
> > 
> > Starting with model 10 of Family 0x10, AMD processors may have
> > support for APERF/MPERF.  Add support for identifying it and using
> > it within cpufreq.  Move the APERF/MPERF functions out of the
> > acpi-cpufreq code and into their own file so they can easily be
> > shared.
> 
> just out of interest: what are the realnames of these processors (>= Mangy-Core) ?

Well, you're going to have to wait and see. Or search the net :)

> > Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > Reviewed-by: Thomas Renninger <trenn@suse.de>
> > ---
> >  arch/x86/kernel/cpu/cpufreq/Makefile       |    4 +-
> >  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   44 +-----------------------
> >  arch/x86/kernel/cpu/cpufreq/mperf.c        |   50
> > ++++++++++++++++++++++++++++ arch/x86/kernel/cpu/cpufreq/mperf.h        | 
> >   9 +++++
> >  arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |    8 ++++
> >  5 files changed, 71 insertions(+), 44 deletions(-)
> >  create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.c
> 
> this file has no copyright or module license, thus tainting my kernel...

This is not a standalone module but only an auxiliary. How does that
taint your kernel? dmesg, .config please.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
