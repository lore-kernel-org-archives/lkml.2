Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1CXQsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:48:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59014 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1CXQsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J3QzbACO+UTFJzGPj0rkWk0PWhXE3OdwjWia87agCKx7EV24Dtr3BbBLGkZ3b9+FCh
         iX5eEbWjRdGnqEkWROQ1M1CLqVt27id8iBHNGvTRMKrHtd4QAVY1N+TJeYvi4Wghq/3n
         3Kmhs5oilx7LLKNPR+YHF/D9VxTLsR8BsgTMI=
Message-ID: <4D8B75A9.3010002@gmail.com>
Date: Thu, 24 Mar 2011 19:47:37 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Add missing read of a counter
 before test
References: <AANLkTikwJFCrpTit8=-=agowkTwZtoyEtFaE7yp0O8MF@mail.gmail.com> <20110324084819.GH30812@elte.hu> <4D8B6569.2030001@gmail.com> <20110324163332.GA2414@elte.hu> <4D8B7570.40101@gmail.com>
In-Reply-To: <4D8B7570.40101@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 07:46 PM, Cyrill Gorcunov wrote:
...
>>
>> So what effect does this have on the regular perf user? Please try to describe 
>> the real-life effect of the bug/problem fixed here.
>>
>> Thanks,
>>
>> 	Ingo
> 
> Unflagged overflows never have been catched due to missed read of a register which
> is to signalize about it, and as result unknown nmi may happen leading to
> "Dazen and confused" message. That is what supposed to be in changelog?
> 

Or you mean the tech details would be appropriate in changelog as well? If so
I could put such details there.

-- 
    Cyrill
