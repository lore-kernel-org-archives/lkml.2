Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab2CHHxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:53:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab2CHHxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:53:09 -0500
Date: Thu, 8 Mar 2012 08:52:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Seebach <peter.seebach@windriver.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anton Blanchard <anton@samba.org>, paulus@samba.org,
        peterz@infradead.org, dsahern@gmail.com, fweisbec@gmail.com,
        yanmin_zhang@linux.intel.com, emunson@mgebm.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120308075247.GA7317@elte.hu>
References: <20120307114249.44275ca3@kryten>
 <20120307010904.GE5656@infradead.org>
 <20120306192912.59811e3e@wrlaptop>
 <20120307203725.GA4333@elte.hu>
 <20120307151951.7e84adb6@wrlaptop>
 <20120308074837.GE20784@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308074837.GE20784@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> [...]
> 
> When designing APIs it is of utmost importance how average 
> developers intuitively *think* it works - not how the designer 
> thinks it should work ... Any severe mismatch between the two 
> is a serious design FAIL that should not be repeated in new 
> code.

Btw., I'm not picking on you, in the last 15 years I have added 
my own sad share of brown paperbag API mis-designs to the Linux 
kernel - most [but not all] of which could fortunately be fixed 
within the kernel.

Thanks,

	Ingo
