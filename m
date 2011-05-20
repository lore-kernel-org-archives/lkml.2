Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935674Ab1ETL4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 07:56:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36246 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935641Ab1ETL4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 07:56:33 -0400
Date: Fri, 20 May 2011 13:56:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 5/9] HWPoison: add memory_failure_queue()
Message-ID: <20110520115614.GH14745@elte.hu>
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
 <1305619719-7480-6-git-send-email-ying.huang@intel.com>
 <20110517084622.GE22093@elte.hu>
 <4DD23750.3030606@intel.com>
 <20110517092620.GI22093@elte.hu>
 <4DD31C78.6000209@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD31C78.6000209@intel.com>
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


* Huang Ying <ying.huang@intel.com> wrote:

> > So why are we not working towards integrating this into our event 
> > reporting/handling framework, as i suggested it from day one on when you 
> > started posting these patches?
> 
> The memory_failure_queue() introduced in this patch is general, that is, it 
> can be used not only by ACPI/APEI, but also any other hardware error 
> handlers, including your event reporting/handling framework.

Well, the bit you are steadfastly ignoring is what i have made clear well 
before you started adding these facilities: THEY ALREADY EXISTS to a large 
degree :-)

So you were and are duplicating code instead of using and extending existing 
event processing facilities. It does not matter one little bit that the code 
you added is partly 'generic', it's still overlapping and duplicated.

Thanks,

	Ingo
