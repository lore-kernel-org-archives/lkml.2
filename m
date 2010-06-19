Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0FSICP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:02:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37058 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab0FSICM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:02:12 -0400
Date: Sat, 19 Jun 2010 10:02:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100619080210.GC18946@basil.fritz.box>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
 <20100612102558.GA4000@elte.hu>
 <4C15A5D1.1040104@jp.fujitsu.com>
 <20100618094838.GD23977@elte.hu>
 <AANLkTimqRwAjrQ_b8BZ28lEn_Gaz5-SpLULWASHD1fVn@mail.gmail.com>
 <20100618124551.GC7612@elte.hu>
 <AANLkTinaPhAcGra6JdmHCVcj9HrNyG2TP91-A8AnQMZE@mail.gmail.com>
 <20100618143532.GA10886@elte.hu>
 <AANLkTimI7efmGNeUkCVT2mUYD8LkYsLAS9chkPhZVA1E@mail.gmail.com>
 <1276875067.1875.133.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276875067.1875.133.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > we can
> > use soft_irq as a backup of self interrupt (for systems without APIC
> > and maybe for other architectures). 
> 
> Whatever would you want to do that for.

The idea is that the work would be done latest on the next
timer interrupt as a fallback if APIC is not available.

That's what mce does already and it's probably approbiate
for most other users too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
