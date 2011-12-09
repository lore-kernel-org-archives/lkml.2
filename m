Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab1LIHLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 02:11:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59506 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab1LIHLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 02:11:47 -0500
Date: Fri, 9 Dec 2011 08:10:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Rientjes <rientjes@google.com>
Cc: Petr Holasek <pholasek@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v3] NUMA x86: add constraints check for nid parameters
Message-ID: <20111209071001.GD24537@elte.hu>
References: <1322739907-4695-1-git-send-email-pholasek@redhat.com>
 <20111201133451.5fc1ee7b.akpm@linux-foundation.org>
 <20111201231441.GA3293@stainedmachine.redhat.com>
 <20111201152851.7e39f034.akpm@linux-foundation.org>
 <20111202105538.GB2188@dhcp-27-244.brq.redhat.com>
 <alpine.DEB.2.00.1112061233330.28251@chino.kir.corp.google.com>
 <20111207194311.GB26060@dhcp-27-244.brq.redhat.com>
 <alpine.DEB.2.00.1112071342450.27360@chino.kir.corp.google.com>
 <20111208121640.GA2229@dhcp-27-244.brq.redhat.com>
 <alpine.DEB.2.00.1112081308430.8127@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112081308430.8127@chino.kir.corp.google.com>
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


* David Rientjes <rientjes@google.com> wrote:

> On Thu, 8 Dec 2011, Petr Holasek wrote:
> 
> > This patch adds constraints checks for numa_set_distance()
> > function. It emits warning and avoids a store to a negative
> > index in numa_distance[] array. Negative ids can be passed when
> > pxm-to-nids mapping is not properly filled while parsing the SRAT.
> > 
> > Signed-off-by: Petr Holasek <pholasek@redhat.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>

Thanks guys.

Just to double check: there's no known instance of such a bad 
SRAT in existence, so this commit can wait until v3.3 and does 
hot have to go into v3.2, right?

Thanks,

	Ingo
