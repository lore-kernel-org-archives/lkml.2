Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab1DNPES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:04:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55753 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758743Ab1DNPER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:04:17 -0400
Date: Thu, 14 Apr 2011 17:03:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
Message-ID: <20110414150351.GA5295@elte.hu>
References: <4DA70950.3060102@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA70950.3060102@openvz.org>
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


Cyrill,

* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> From: Don Zickus <dzickus@redhat.com>
> Subject: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
...
> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

When forwarding patches please always use Signed-off-by, not Acked-by - 
especially when you also edit the patch slightly.

Is it fine to you if i add your SOB to this patch?

Thanks,

	Ingo
