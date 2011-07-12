Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab1GLSgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:36:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:44496 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab1GLSgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:36:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,522,1304319600"; 
   d="scan'208";a="26854694"
Subject: Re: [PATCH] x86, x2apic: Preserve high 32-bits of IA32_APIC_BASE
 MSR
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <4E1C90B4.4030604@zytor.com>
References: <20110712055831.2498.78521.sendpatchset@nchumbalkar.americas.cpqcorp.net>
	 <1310491776.12417.31.camel@sbsiddha-MOBL3.sc.intel.com>
	 <4E1C90B4.4030604@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 12 Jul 2011 11:36:05 -0700
Message-Id: <1310495765.12417.32.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 11:21 -0700, H. Peter Anvin wrote:
> On 07/12/2011 10:29 AM, Suresh Siddha wrote:
> > 
> > yeah, I don't think it was intentional.
> > 
> > Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > 
> 
> This isn't 3.0 material, though (no manifest error), correct?

Yep. Right Naga?

