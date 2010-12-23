Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab0LWOEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 09:04:21 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57354 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab0LWOEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:04:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=dkim-signature:domainkey-signature:mime-version:in-reply-to
         :references:date:message-id:subject:from:to:cc:content-type;
        b=ozVnuaC7UkA9qjVcwZoHyAD9DY7mhqNcVEFSzyLalZ9ME3HZC2ykv5BqzjjRWJes9L
         ZwC+1qfmtiKheNQGG/pLNvKGoA/bLtinMjQWD84bAz/CTefMhCIPEhShU7ZLpXzNRazC
         RLrcckaW5fAsiOMPMITyH1z1+dlmoTbcleEHw=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oz/SzxQnTHcVqf88pUAeYOdbscY0pfGGxiOtxz8p16g5G3RYjLS3/SfnKdPoomfVsk
         oQfOBudepUES+Rr+xBkB7dP3VRy12qzEW0QJCcSkyOnn7uzIq9swO1PZ/mHSdg0zsa3G
         +HG9yb4fQnx98W+cilNhLNdKcp6ZD2zJaZKvQ=
MIME-Version: 1.0
In-Reply-To: <1293110258.3390.41.camel@Palantir>
References: <20101223113926.GH14960@siel.b>
	<1293110258.3390.41.camel@Palantir>
Date: Thu, 23 Dec 2010 15:04:14 +0100
Message-ID: <AANLkTi=1v6YG-Vc7uZFvqO6K0fAuZ-o9A7hxeZVVAHm3@mail.gmail.com>
Subject: Re: Sending some form of notifaction when sched_fifo throttling kicks in...
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Dario Faggioli <raistlin@linux.it>
Cc: torbenh <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Gregory Haskins <ghaskins@novell.com>,
        Nick Piggin <nickpiggin@yahoo.com.au>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, vatsa@in.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

?
>>
> ... If you think you're fine with some /proc (and perhaps cpuacct, if
> cgroups are being used) readable, I can try to come up with something.
>

There is no point in putting it in cpuacct since cpuacct can be used
separately from cpu.

> I think that the number of times that throttling fired and the last
> throttling instant could be exported this way without much issues.
>
> Do others have some idea and/or comments about that? This is
> ABI/interface, and that really scares me! :-P

IIRC, your patchset had something like this for getting the
statistics? Starting fromt hre, would schedstats be the right place?

Dhaval
