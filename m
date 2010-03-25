Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0CYJuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:50:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab0CYJuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:50:13 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 0/5] powernow-k8: Core Performance Boost and effective frequency support
Date: Thu, 25 Mar 2010 10:50:09 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: akpm@linux-foundation.org, davej@redhat.com, linux@dominikbrodowski.net,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       cpufreq@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
References: <1269452783-966-1-git-send-email-bp@amd64.org>
In-Reply-To: <1269452783-966-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201003251050.09737.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010 18:46:18 Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi all,
> 
> here's the reworked version after incorporating most of your comments.
> 
> In particular, this version adds a /proc/cpuinfo flag and removes the
> scaling_cur_freq interface overload in favor of cpufreq-aperf userspace
> tool.
> 
> Please review,
Beside the one (Intel/AMD) duplicate APERF/MPERF cpuid check which
I expect can get unified, looks fine to me.

Thanks,

    Thomas
