Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1EQHDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:03:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60940 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab1EQHDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:03:35 -0400
Date: Tue, 17 May 2011 09:03:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fenghua Yu <fenghua.yu@intel.com>, Avi Kivity <avi@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Enable SMEP CPU Feature
Message-ID: <20110517070308.GC22305@elte.hu>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
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


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Intel new CPU supports SMEP (Supervisor Mode Execution Protection). SMEP
> prevents kernel from executing code in application. Updated Intel SDM describes
> this CPU feature. The document will be published soon.
> 
> Note: This patch set doesn't enable the SMEP feature in KVM. If it's needed,
> another patch will be pushed for enabling the feature in KVM.

We can do it separately from native kernel support, but i'm sure Avi would 
agree that SMEP support in KVM would be nice! (as long as it's configurable as 
well, there might be guest OSs that break if SMEP is enabled, right?)

Thanks,

	Ingo
