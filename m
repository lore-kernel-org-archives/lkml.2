Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1BFTVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:21:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33114 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1BFTVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:21:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jw+3mg7OYPzc3G6ofa4w6glI0RuhF+hBSwNNUxE/s6YEl6Kac8bWBHwWKbQCz/5Jot
         ITxqBJ2vhozkIZmL1NSwYrMgGuJmJJD2Dg4406IDshL1pvvDYLtraqQFDVQdNkHtANWO
         EDhPqjh9lqo81bKN5pJwlGEjHXRRl8qwbWxa8=
Message-ID: <4D4EF4BC.6040206@gmail.com>
Date: Sun, 06 Feb 2011 22:21:32 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, George Spelvin <linux@horizon.com>,
        Meelis Roos <mroos@linux.ee>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test
References: <AANLkTin5gCnhVos3Lu_0GZSxFQmvsNEYTO=Jq7UdmYb1@mail.gmail.com> <20110204165944.GB21209@redhat.com>
In-Reply-To: <20110204165944.GB21209@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 07:59 PM, Don Zickus wrote:
> On Fri, Feb 04, 2011 at 03:17:28PM +0300, Cyrill Gorcunov wrote:
>> Please apply it, sorry for non-inlined patch (have a web access only at moment).
>>
>> Note that I've tested the patch on non-HT machine so if someone have HT'ed one
>> -- it would be great to test the patch there.
> 
> Hmm. For some reason, when I enable the kgdb testsuite, the box fails to
> boot with hardlockup issues.  It seems like the code is swallowing the
> NMIs? I basically applied this patch on top of 2.6.38-rc3 and ran it on my
> Xeon box (p4 w/HT).
> 
> Cheers,
> Don

  Don, I hope to get access to p4 machine tomorrow and investigate this issue
(didn't manage to read kgdb code this weekend). Sorry for delay.

-- 
    Cyrill
