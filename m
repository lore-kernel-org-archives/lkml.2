Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2BSNsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 08:48:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51159 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab2BSNsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 08:48:45 -0500
Date: Sun, 19 Feb 2012 14:48:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "hpanvin@gmail.com" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Test saved %rip in NMI to determine
 nested NMI
Message-ID: <20120219134839.GA30091@elte.hu>
References: <1329617173.1561.5.camel@acer.local.home>
 <20120219125601.GD25900@elte.hu>
 <0e44abc3-f1a9-4c5b-88a8-baa563f57067@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e44abc3-f1a9-4c5b-88a8-baa563f57067@email.android.com>
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


* hpanvin@gmail.com <hpa@zytor.com> wrote:

> Vsyscall page, not vdso...

yes - same general purpose: user-space execution happens in the 
kernel address range.

Thanks,

	Ingo
