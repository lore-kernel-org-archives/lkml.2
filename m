Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab1LIHNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 02:13:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40817 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab1LIHM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 02:12:59 -0500
Date: Fri, 9 Dec 2011 08:11:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Petr Holasek <pholasek@redhat.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v2] NUMA x86: add constraints check for nid parameters
Message-ID: <20111209071109.GE24537@elte.hu>
References: <1322739907-4695-1-git-send-email-pholasek@redhat.com>
 <20111201133451.5fc1ee7b.akpm@linux-foundation.org>
 <20111201231441.GA3293@stainedmachine.redhat.com>
 <20111201152851.7e39f034.akpm@linux-foundation.org>
 <20111202105538.GB2188@dhcp-27-244.brq.redhat.com>
 <alpine.DEB.2.00.1112061233330.28251@chino.kir.corp.google.com>
 <20111207194311.GB26060@dhcp-27-244.brq.redhat.com>
 <m2mxb2nb58.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2mxb2nb58.fsf@firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Petr Holasek <pholasek@redhat.com> writes:
> 
> > This patch adds constraints checks for numa_set_distance()
> > function. It emits warning when pxms are used uninitialized
> > when parsing the SRAT.
> 
> Can you expand on the motivation for this please?
> Is this to catch buggy code or to catch buggy SRATs?

Both.

> If the later are they actually out there?

Not that i know of - they would likely not boot Linux very well 
today.

Thanks,

	Ingo
