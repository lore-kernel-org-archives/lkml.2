Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab2BVTLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:11:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52022 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab2BVTLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:11:12 -0500
Message-ID: <4F453DB4.7090900@zytor.com>
Date: Wed, 22 Feb 2012 11:10:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Richard Henderson <rth@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
References: <4F449ACF.3040807@zytor.com> <20120222074839.GA24890@elte.hu> <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com> <20120222080659.GA25318@elte.hu> <1329916920.25686.79.camel@gandalf.stny.rr.com> <20120222133404.GA14085@elte.hu> <1329918881.25686.92.camel@gandalf.stny.rr.com> <1329923583.24994.21.camel@twins> <1329924752.24994.25.camel@twins> <4F45226B.50606@redhat.com> <20120222185809.GI3405@redhat.com>
In-Reply-To: <20120222185809.GI3405@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 10:58 AM, Jason Baron wrote:
> 
> I don't think I ever quite got it working, and I've unfortunately
> misplaced it at this point. I am definitely interested in trying it
> again though. If you can re-send it, I'll try it.
> 
> Also, I think I seem to recall it wouldn't help the -Os case, b/c we
> don't get block re-ordering?
> 

With -Os, your code is going to suck eggs no matter what.

	-hpa



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

