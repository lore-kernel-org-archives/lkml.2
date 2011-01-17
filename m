Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab1AQQVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 11:21:15 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49035 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1AQQVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 11:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DAtM6PnCIZ5H+QdP5EH0fUfTBRPlx+nWLRPlxzrSrEFHEkhKssZ1ePw4zj2HtVAc45
         tThOjh6rKk3HqveC1aAvljFD8Yk4blhSR1r6CNKyT4DtzZgm9e+h1vF8CoLcd3PpeMjQ
         8pGFHQskAKtDvEQLfn+EqYw7BhM0Wwh+ZiFD8=
Date: Mon, 17 Jan 2011 17:21:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH] tracing, perf : add cpu hotplug trace events
Message-ID: <20110117162105.GA1778@nowhere>
References: <AANLkTimsR3=BKSF8EyASu4_T_vTznw4yEqmxPS8gOQCy@mail.gmail.com>
 <20110107151200.GB1736@nowhere>
 <AANLkTi=L3=_2dzHH4Wu6QWXw=AUjxtrAu60xfM3-Qwn4@mail.gmail.com>
 <20110114183516.GB1926@nowhere>
 <AANLkTi=nugnkimG75Qh3t2vu8-qy2LKKHwoY2FFFpWDp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=nugnkimG75Qh3t2vu8-qy2LKKHwoY2FFFpWDp@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 07:49:58AM -0600, Vincent Guittot wrote:
> I was just wondering which tracepoints format between my 1st proposal
> and yours was the easier to post process by an application like
> pytimechart.

No idea as pytimechart uses his own ad hoc event parsing. Either
way there won't be much differences though.

> I have updated the cpu hotplug tracepoint according to your remarks
> and steve's ones. I have just replaced the second
> cpu_arch_die_start/end in your proposal by cpu_arch_dead_start/endfrq

Tracepoints tend to describe actions rather than states, although I can
show you some exceptions as well. But this tends to be the major
tendency. I suggest you to be stay consistent with this scheme.

Thanks.
