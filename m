Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab2JSP3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:29:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13945 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2JSP3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:29:20 -0400
X-Authority-Analysis: v=2.0 cv=PucRnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=B91VBO2a_qwA:10 a=LNLIg6nQSpYA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=g8XX_L_LDKoA:10 a=snv08Ws5mTa4Q6OXkcsA:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Date: Fri, 19 Oct 2012 11:29:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@localhost.localdomain
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT] slab: Fix up stable merge of slab init_lock_keys()
In-Reply-To: <1350656961.2768.20.camel@twins>
Message-ID: <alpine.DEB.2.02.1210191127320.9958@localhost.localdomain>
References: <1350567601.19292.69.camel@pippen.local.home> <1350656961.2768.20.camel@twins>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Oct 2012, Peter Zijlstra wrote:

>> Could you just confirm that my fix is correct.
>
> We forever keep getting that issue wrong it seems.. so I'd not put too
> much trust into whatever my sleep addled brain thinks today :/

I wasn't expecting a reply till next week ;-)

>
> Looks about right, but who knows ;-)
>

Heh, OK, the worse thing that can happen is that I revert it for the next 
-rt stable release. I wont hold off the releases to 3.2-rt and 3.4-rt over 
this.

Thanks,

-- Steve

