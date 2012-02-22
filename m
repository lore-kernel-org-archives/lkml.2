Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2BVPkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 10:40:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50836 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab2BVPkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 10:40:45 -0500
Message-ID: <4F450C5F.7080309@zytor.com>
Date: Wed, 22 Feb 2012 07:40:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
References: <4F44934B.2000808@zytor.com> <20120222072538.GA17291@elte.hu> <4F449ACF.3040807@zytor.com> <20120222074839.GA24890@elte.hu> <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com> <20120222080659.GA25318@elte.hu> <1329916920.25686.79.camel@gandalf.stny.rr.com> <20120222133404.GA14085@elte.hu> <1329918881.25686.92.camel@gandalf.stny.rr.com> <20120222145614.GA2491@elte.hu> <20120222151943.GA2370@redhat.com>
In-Reply-To: <20120222151943.GA2370@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 07:19 AM, Jason Baron wrote:
> 
> Right, we've discussed an 'unbiased' variant a bit before, but I don't 
> have a working imlementation for it yet. But I agree all current users are of
> the biased variety.
> 
> Also, decoupling the higher level interfaces, as Ingo has suggested - 
> 'very_unlikely' 'static_key', from the lower level 'jump label' naming makes
> sense. We might eventually add an 'unbias' variant. Another potential variant
> is in the 'bias' case is to move the mostly not taken branch even further out
> of line. Another possibilty is a 'switch'-like variant or multi-way jump.
> 

Okay, at least we need something to connect the readout with the key,
otherwise there is nothing that even hints that they are part of the
same fundamental subsystem...

I don't know if key_likely() and key_unlikely() would make sense...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

