Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab1DYOF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:05:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52829 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab1DYOF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ab/sKUU1MOZpPLRQrZSJVof7259hE12dA3+IdbFWHyiFQ8qPpDAu8sxiQ+SVUfeb41
         hrBsWMlMvNP2H6tO4qeVSV092n8qGLjw6IYwMvD6n2XDuuYKYUfB1z3Ib8vFC0/j+KNu
         il6cUWWLbuuQXgMzygYf5d4oRnuftSZrPfYTM=
Message-ID: <4DB57FA3.204@gmail.com>
Date: Mon, 25 Apr 2011 18:05:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com> <1303398203-2918-5-git-send-email-dzickus@redhat.com> <20110422081838.GA24011@elte.hu> <BANLkTimh80LorfC8O-HOPAAWK9BLYNjcXA@mail.gmail.com> <1303462476.2035.215.camel@laptop> <BANLkTi=Eoa9jpiLmFTgcNrY334ZAfz6P=w@mail.gmail.com> <1303465546.2035.224.camel@laptop> <4DB19B80.5000900@gmail.com> <20110425134126.GB20887@redhat.com>
In-Reply-To: <20110425134126.GB20887@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2011 05:41 PM, Don Zickus wrote:
> On Fri, Apr 22, 2011 at 07:15:12PM +0400, Cyrill Gorcunov wrote:
>> On 04/22/2011 01:45 PM, Peter Zijlstra wrote:
>> ...
>>>
>>> Right, so the idea is that one event (concept) has two (or more)
>>> representations in the config space. And when scheduling the events we
>>> find we have a conflict, we simply try the alternative encoding(s).
>>>
>> ...
>>
>>   Yeah, Peter, I think it's quite possible to use alternative encoding for p4 as well,
>> not sure tho if some "generalized" approach for all perf would be applied to p4 but
>> we can make event "aliases" being per-pmu eventually.
>>
>>   So Ingo, drop this patch then ;)
> 
> Eek, when can you have an alternate patch for this Cyril?  I just want to
> make sure this can still eventually find its way into 2.6.40.
> 
> Cheers,
> Don

  I need kinda aliases for events (or alternative scheme as PeterZ mentions),
Don I'll try to make something tomorrow, ok? With aliases we would not need
to even modify sources outside of p4 pmu which is good i think. I've some spare
bits in low hw:config bits so this aliases could go there as a start.

-- 
    Cyrill
