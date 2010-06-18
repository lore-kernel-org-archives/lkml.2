Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab0FRPbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 11:31:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:40601 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab0FRPbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 11:31:24 -0400
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
From: Peter Zijlstra <peterz@infradead.org>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <AANLkTimI7efmGNeUkCVT2mUYD8LkYsLAS9chkPhZVA1E@mail.gmail.com>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
	 <20100612102558.GA4000@elte.hu> <4C15A5D1.1040104@jp.fujitsu.com>
	 <20100618094838.GD23977@elte.hu>
	 <AANLkTimqRwAjrQ_b8BZ28lEn_Gaz5-SpLULWASHD1fVn@mail.gmail.com>
	 <20100618124551.GC7612@elte.hu>
	 <AANLkTinaPhAcGra6JdmHCVcj9HrNyG2TP91-A8AnQMZE@mail.gmail.com>
	 <20100618143532.GA10886@elte.hu>
	 <AANLkTimI7efmGNeUkCVT2mUYD8LkYsLAS9chkPhZVA1E@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Jun 2010 17:31:07 +0200
Message-ID: <1276875067.1875.133.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 23:16 +0800, huang ying wrote:
> 
> soft_irq is a delayed mechanism for IRQ,

No its not.

>  a self interrupt can be a
> delayed mechanism for NMI. If we can make soft_irq NMI-safe, 

No you can't.

> we can
> use soft_irq as a backup of self interrupt (for systems without APIC
> and maybe for other architectures). 

Whatever would you want to do that for.
