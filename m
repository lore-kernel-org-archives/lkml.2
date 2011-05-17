Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1EQHFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:05:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57158 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab1EQHFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:05:45 -0400
Date: Tue, 17 May 2011 09:05:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 0/4] Enable SMEP CPU Feature
Message-ID: <20110517070527.GD22305@elte.hu>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
 <4DD19C81.8000902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD19C81.8000902@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 05/16/2011 02:34 PM, Fenghua Yu wrote:
> > 
> > Note: This patch set doesn't enable the SMEP feature in KVM. If it's needed,
> > another patch will be pushed for enabling the feature in KVM.
> > 
> 
> Hi Avi,
> 
> Could you comment on if this needs to be a gating factor?

I think KVM would benefit from the native kernel playing guinea pig whether 
SMEP is really, truly 100% trouble-free to enable by default (for Linux) ;-)

Some programmable configurability seems necessary on the KVM side, as KVM has 
no control over how sane the guest kernel is.

Thanks,

	Ingo
