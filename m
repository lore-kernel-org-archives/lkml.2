Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab0GHNXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:23:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:15724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229Ab0GHNXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:23:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,558,1272870000"; 
   d="scan'208";a="533558716"
Subject: Re: -tip tree panic
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "Ma, Ling" <ling.ma@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100708101753.GA32462@elte.hu>
References: <1278612020.2164.11.camel@localhost>
	 <20100708101753.GA32462@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 21:23:05 +0000
Message-Id: <1278624185.2164.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 18:17 +0800, Ingo Molnar wrote:
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > I just tried latest -tip tree(commit 25fe86a), but it panics.
> 
> These commits might be relevant:
> 
>  bdc802d: x86, cpu: Support the features flags in new CPUID leaf 7
>  83a7a2a: x86, alternatives: Use 16-bit numbers for cpufeature index
>  24da9c2: x86, cpu: Add CPU flags for F16C and RDRND

Still panics.

> 
> So you could try reverting them. If that doesnt work out please try to bisect 
> it.

Will bisect tomorrow when I back to office.

Lin Ming

> 
> Thanks,
> 
> 	Ingo


