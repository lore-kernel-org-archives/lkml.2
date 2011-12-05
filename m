Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab1LEKYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:24:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46041 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab1LEKYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:24:04 -0500
Date: Mon, 5 Dec 2011 11:22:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: hpa@zytor.com, tglx@linutronix.de, suresh.b.siddha@intel.com,
        eranian@google.com, brgerst@gmail.com, robert.richter@amd.com,
        Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] rework of extended state handling, LWP support
Message-ID: <20111205102223.GA3143@elte.hu>
References: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322570488-21798-1-git-send-email-hans.rosenfeld@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:

> These patches were built and tested against 3.1. The older RFC 
> patches that have been lingering in tip/x86/xsave for the last 
> few months should be removed.

They have been lingering because of negative review feedback i 
have given to you about LWP. I'm not convinced about the current 
form of abstraction that this patch-set offers.

See this past discussion from half a year ago:

  Subject: Re: [RFC v3 0/8] x86, xsave: rework of extended state handling, LWP support

We can and should do better than that.

Thanks,

	Ingo
