Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2BVPMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:12:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50688 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab2BVPLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:11:49 -0500
Message-ID: <4F450599.6040103@zytor.com>
Date: Wed, 22 Feb 2012 07:11:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
References: <20120222065016.GA16923@elte.hu> <4F44934B.2000808@zytor.com> <20120222072538.GA17291@elte.hu> <4F449ACF.3040807@zytor.com> <20120222074839.GA24890@elte.hu> <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com> <20120222080659.GA25318@elte.hu> <1329916920.25686.79.camel@gandalf.stny.rr.com> <20120222133404.GA14085@elte.hu> <1329918881.25686.92.camel@gandalf.stny.rr.com> <20120222145614.GA2491@elte.hu>
In-Reply-To: <20120222145614.GA2491@elte.hu>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 06:56 AM, Ingo Molnar wrote:
> 
>> maybe even a "very_likely()", but then keep a static_branch() 
>> or whatever for those cases you do not want to optimize at 
>> compile time.
> 
> Once such uses arise maybe we could add such an 'unbiased' 
> variant.
> 

We already have such use cases, although a lot of them are covered by
static_cpu_has().  However,  I fully expect that we'll have cases that
aren't readily covered by CPU feature flags and I'd like to avoid
reinventing new features.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

