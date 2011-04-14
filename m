Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933839Ab1DNSOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:14:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36099 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933701Ab1DNSOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:14:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h/cGbjOlv4X41iznqhVBTeTByWfNZxx/Zw6u6wuZld7Eqruswgx3usOReMtanzFJBY
         LAO92zXuwp8Ew/X4eWB1bb/lDxT1awAFxxfvcVZ/hDXfwcRN8tOtru6xfUi4I/96lLf5
         xK79lkuQugBgeKYin/nn83XPIRMYfmb5l2toY=
Message-ID: <4DA73990.5070603@gmail.com>
Date: Thu, 14 Apr 2011 22:14:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Shaun Ruffell <sruffell@digium.com>
CC: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
References: <4DA70950.3060102@openvz.org> <20110414174327.GA8863@elte.hu> <20110414174420.GA8950@elte.hu> <4DA733B1.1010702@gmail.com> <20110414181226.GA14390@digium.com>
In-Reply-To: <20110414181226.GA14390@digium.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 10:12 PM, Shaun Ruffell wrote:
> On Thu, Apr 14, 2011 at 09:49:37PM +0400, Cyrill Gorcunov wrote:
>> On 04/14/2011 09:44 PM, Ingo Molnar wrote:
>>>
>>> below is the commit which needs to be fixed - note that i improved the 
>>> changelog, please keep these fixes for future submissions.
>>
>> Yes, thanks, i'll ping back as only get nit resolved.
> 
> Cyrill, I had not been running perf when I was testing, but I was able to
> reproduce what Ingo reported. I'll make sure to run that on any future tests
> as well. My apologies.

It's mine error, no need for apologies. I suspect this issue might be related
to shared MSRs (iirc nehalem have some MSRs shared as well). I'm checking which
one might be involved.

-- 
    Cyrill
