Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935637Ab1ETLqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:46:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39341 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab1ETLqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:46:34 -0400
Date: Fri, 20 May 2011 13:46:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rao, Nikhil" <nikhil.rao@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  x86: Removing unnecessary check in detect_ht
Message-ID: <20110520114620.GE14745@elte.hu>
References: <43F901BD926A4E43B106BF17856F0755018E1CF69D@orsmsx508.amr.corp.intel.com>
 <1305048201.2736.17.camel@sbsiddha-MOBL3.sc.intel.com>
 <1F668163772FA946975B9466A9DFF729B5E5@ORSMSX101.amr.corp.intel.com>
 <1F668163772FA946975B9466A9DFF729B64C@ORSMSX101.amr.corp.intel.com>
 <20110518210754.GA28476@elte.hu>
 <1F668163772FA946975B9466A9DFF729B6A3@ORSMSX101.amr.corp.intel.com>
 <20110518212351.GE28476@elte.hu>
 <1F668163772FA946975B9466A9DFF729B7E4@ORSMSX101.amr.corp.intel.com>
 <20110519180940.GD6139@elte.hu>
 <1F668163772FA946975B9466A9DFF729BEDD@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1F668163772FA946975B9466A9DFF729BEDD@ORSMSX101.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rao, Nikhil <nikhil.rao@intel.com> wrote:

> This patch removes a check that causes incorrect scheduler domain setup (SMP instead of SMT) and bootlog warning messages when cpuid extensions for topology enumeration are not supported and the number of processors reported to the OS is smaller than smp_num_siblings
> 
> Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
>  arch/x86/kernel/cpu/common.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c index cbc70a2..d2bcd54 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -477,13 +477,6 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
>         if (smp_num_siblings <= 1)
>                 goto out;
>  
> -       if (smp_num_siblings > nr_cpu_ids) {
> -               pr_warning("CPU: Unsupported number of siblings %d",
> -                          smp_num_siblings);
> -               smp_num_siblings = 1;
> -               return;
> -       }
> -

Your patch does not apply because it's whitespace damaged (all tabs got 
converted to spaces). Please see Documentation/email-clients.txt.

Thanks,

	Ingo
