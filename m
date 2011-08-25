Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1HYRWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:22:41 -0400
Received: from ch-smtp05.sth.basefarm.net ([80.76.153.6]:55154 "EHLO
	ch-smtp05.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab1HYRWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:22:40 -0400
Message-ID: <4E56848C.90801@fastmail.fm>
Date: Thu, 25 Aug 2011 19:21:16 +0200
From: anders eriksson <aeriksson@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110813 Thunderbird/5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: mtrr failure, 3.1-rc1
References: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org> <CA+55aFzndqkSC1z3==HqUGC8hP=pw62ro3CWYtovk95_cYAKsA@mail.gmail.com> <20110825164649.GL2803@mtj.dyndns.org>
In-Reply-To: <20110825164649.GL2803@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.252.233.92
X-Scan-Result: No virus found in message 1Qwdd7-0005rC-HV.
X-Scan-Signature: ch-smtp05.sth.basefarm.net 1Qwdd7-0005rC-HV b2461b06379fd37fe97f7cdb4016364f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-25 18:46, Tejun Heo wrote:
> Indeed, while removing custom rendezvous code and switching to
> stop_machine, commit 192d8857427d "x86, mtrr: use stop_machine APIs
> for doing MTRR rendezvous" completely dropped mtrr setting code on
> !CONFIG_SMP.
>
> Anders, if your kernel didn't have SMP turned on, can you please
> verify the following patch fixes the problem?
Yes. It's single CPU compiled with !CONFIG_SMP. I'm compiling w/ this 
patch right now.
Takes a while on vintage equipment... ;-)

