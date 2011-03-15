Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1COWc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:32:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44271 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1COWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:32:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=AR77a4j9r44QFn8H5J0j1yW6BAsqdm8m4SwTVYlE3aCssSN99TCQcaqIBb1dkyFLXB
         bETSLGPF6kTnp1jqayUo0oCqmp65frImy2EIjL1mg2OhMVbi37jBETLiHrYqs4jDRqJk
         rEuU4jIhSeinQFRTMtnrOgyp8eY2pQ72n20AE=
MIME-Version: 1.0
In-Reply-To: <smp-ipi-mask-clear-race-v3@mdm.bga.com>
References: <20110112150740.77dde58c@kryten>
	<1295288253.30950.280.camel@laptop>
	<smp-call-function-peter-reply@mdm.bga.com>
	<smp-call-function-move-writes@mdm.bga.com>
	<1296145360.15234.234.camel@laptop>
	<smp-call-function-list-race@mdm.bga.com>
	<smp-call-function-list-race-fix@mdm.bga.com>
	<1296458482.7889.175.camel@marge.simson.net>
	<ipi-list-reply@mdm.bga.com>
	<smp-ipi-mask-clear-race-v3@mdm.bga.com>
Date: Tue, 15 Mar 2011 22:32:25 +0000
X-Google-Sender-Auth: hrqlfjzuqBFUnAnec6NzcxIXjgU
Message-ID: <AANLkTinZX23QwpTN92RLAH6LkxgHZhawrL+dFXTzAs98@mail.gmail.com>
Subject: Re: [PATCH 3/4 v3] smp_call_function_many: handle concurrent clearing
 of mask
From: Catalin Marinas <catalin.marinas@arm.com>
To: Milton Miller <miltonm@bga.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Dimitri Sivanich <sivanich@sgi.com>,
        Tony Luck <tony.luck@intel.com>, Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Blanchard <anton@samba.org>,
        "xiaoguangrong@cn.fujitsu.com" <xiaoguangrong@cn.fujitsu.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 15 March 2011, Milton Miller <miltonm@bga.com> wrote:
> Mike Galbraith reported finding a lockup ("perma-spin bug") where the
> cpumask passed to smp_call_function_many was cleared by other cpu(s)
> while a cpu was preparing its call_data block, resulting in no cpu to
> clear the last ref and unlock the block.

I missed your patch and just posted something similar. I'll leave it
to you then ;)

https://lkml.org/lkml/2011/3/15/296

Catalin

-- 
Catalin
