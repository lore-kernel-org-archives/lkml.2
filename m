Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775Ab1ETIVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:21:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53676 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934688Ab1ETIVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:21:40 -0400
Date: Fri, 20 May 2011 10:21:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Shan, Haitao" <haitao.shan@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 0/4] Enable SMEP CPU Feature
Message-ID: <20110520082117.GA22802@elte.hu>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
 <4DD19C81.8000902@zytor.com>
 <20110517070527.GD22305@elte.hu>
 <4DD23CB6.3050503@redhat.com>
 <20110517092903.GJ22093@elte.hu>
 <4DD2409F.4030800@redhat.com>
 <20110517104654.GN22093@elte.hu>
 <4DD25D29.9040008@redhat.com>
 <625BA99ED14B2D499DC4E29D8138F1505C9BEEF80B@shsmsx502.ccr.corp.intel.com>
 <04F972F38B3C4E4E91C4697DA8BF9F525B208891C9@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04F972F38B3C4E4E91C4697DA8BF9F525B208891C9@shsmsx502.ccr.corp.intel.com>
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


* Shan, Haitao <haitao.shan@intel.com> wrote:

> After this basic enabling work, we could work out a patch to address Ingo's 
> idea, which will mandatorily turn on SMEP for guests.

FYI, basic host arch/x86/ kernel SMEP support is now upstream (sent it to Linus 
yesterday) and will be released as part of v2.6.40.

Thanks,

	Ingo
