Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0FXGuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 02:50:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:16340 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab0FXGup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 02:50:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,472,1272870000"; 
   d="scan'208";a="633141210"
Subject: Re: [RFC][PATCH] irq_work
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1277362073.1875.839.camel@laptop>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277361352.1875.838.camel@laptop>
	 <1277361791.3947.11.camel@yhuang-dev.sh.intel.com>
	 <1277362073.1875.839.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 14:50:43 +0800
Message-ID: <1277362243.3947.20.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 14:47 +0800, Peter Zijlstra wrote:
> On Thu, 2010-06-24 at 14:43 +0800, Huang Ying wrote:
> > Hi, Peter,
> 
> > I fact I uses exactly the similar method in my patches, just trigger it
> > with soft_irq instead of IRQ. Please take a look at
> > nmi_return_notifier_schedule in
> 
> But then why still use softirq? Once you have this its completely
> useless.

Some systems have no self interrupt, for example the system without
APIC. We need to provide a fallback for them. soft_irq can help here.

Best Regards,
Huang Ying


