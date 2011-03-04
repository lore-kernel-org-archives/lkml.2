Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab1CDUfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:35:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46469 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1CDUfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:35:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ouEifbcyDYPQKkqZnyNkjDiqDu3SeDgOEke/s2lARVaq7zPxzCPS0akFtarr0IIMdF
         U2n7MEynt2aH+mZk4uSlZaWQ3vKmYYQWDTnqj4bbUhpAQ72ejg/1B/iMmtoqfupkEp4P
         I1fw9LTidaP9m25R6+0hqFmdSi1LPXX8zC1fQ=
Message-ID: <4D714D1A.1080901@gmail.com>
Date: Fri, 04 Mar 2011 23:35:38 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: P4 PMU -- Address erratum 15 and 17
References: <4D7141FC.8000504@gmail.com> <1299269134.1929.60.camel@Joe-Laptop> <4D714CC8.3060107@gmail.com>
In-Reply-To: <4D714CC8.3060107@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 11:34 PM, Cyrill Gorcunov wrote:
> On 03/04/2011 11:05 PM, Joe Perches wrote:
>> On Fri, 2011-03-04 at 22:48 +0300, Cyrill Gorcunov wrote:
>>> Errata N15 and 17 of 249199-071 should be taken
>>> into account. They are mostly hard to hit at moment
>>> i believe but still better to be fixed.
>>
>> Trivia:
>>
>>> +			printk_once("P4 PMU: Recover lost carry bit\n");
>>
> 
> D0h. Joe you point to missed KERN_WARNING, right?
> 

Ah, sorry found what you mean ;) Thanks!
I'll update as only the rest will be reviewed.

-- 
    Cyrill
