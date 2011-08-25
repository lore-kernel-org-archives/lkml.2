Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab1HYSBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:01:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50749 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab1HYSBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:01:20 -0400
Message-ID: <4E568DD1.5010501@zytor.com>
Date: Thu, 25 Aug 2011 11:00:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Anders Eriksson <aeriksson@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtrr: fix UP breakage caused during switch to stop_machine
References: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org> <CA+55aFzndqkSC1z3==HqUGC8hP=pw62ro3CWYtovk95_cYAKsA@mail.gmail.com> <20110825164649.GL2803@mtj.dyndns.org> <1314294182.16133.19.camel@sbsiddha-desk.sc.intel.com> <CA+55aFwaxzFJCjJc1=6utMq0WQmrP4COGEOQirqBLcmdTf=+rQ@mail.gmail.com> <20110825174656.GN2803@mtj.dyndns.org>
In-Reply-To: <20110825174656.GN2803@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 10:46 AM, Tejun Heo wrote:
> While removing custom rendezvous code and switching to stop_machine,
> commit 192d8857427d "x86, mtrr: use stop_machine APIs for doing MTRR
> rendezvous" completely dropped mtrr setting code on !CONFIG_SMP
> breaking MTRR settting on UP.  Fix it by removing the incorrect
> CONFIG_SMP.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Anders Eriksson <aeriksson@fastmail.fm>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>

Acked-by: H. Peter Anvin <hpa@zytor.com>

Linus, are you picking this up from email or should I put it in x86/urgent?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

