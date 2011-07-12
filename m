Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1GLSWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:22:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44062 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab1GLSWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:22:18 -0400
Message-ID: <4E1C90B4.4030604@zytor.com>
Date: Tue, 12 Jul 2011 11:21:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] x86, x2apic: Preserve high 32-bits of IA32_APIC_BASE
 MSR
References: <20110712055831.2498.78521.sendpatchset@nchumbalkar.americas.cpqcorp.net> <1310491776.12417.31.camel@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <1310491776.12417.31.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 10:29 AM, Suresh Siddha wrote:
> 
> yeah, I don't think it was intentional.
> 
> Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 

This isn't 3.0 material, though (no manifest error), correct?

	-hpa
