Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1B0LTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 06:19:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53582 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1B0LTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 06:19:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=axp2+VXpdo5MzmOfX8hn68D6adxtmXnnPoSlTyYrakk8GI9g5c8PD/pY1TZx/ggbRi
         2USRhVAvb2xuZ9OX/hGWR9Z6qk/GymuH6os4lHKcDzREfPrvtDKjQdwh6f5XR3gsOoG0
         UNytrFDfaXqK/6DfiQIcAW0Vp2LqKfep/sEXo=
Message-ID: <4D6A332F.3080603@gmail.com>
Date: Sun, 27 Feb 2011 14:19:11 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Don Zickus <dzickus@redhat.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] x86, NMI: Allow NMI reason io port (0x61) to be processed
 on any CPU
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>	<1294348732-15030-6-git-send-email-dzickus@redhat.com>	<alpine.LFD.2.00.1102230227010.31425@eddie.linux-mips.org>	<4D68B397.6040809@gmail.com>	<AANLkTi==WbHfLrWAjFCZU9VAhfyf9MLnvKza=i9PuO7r@mail.gmail.com>	<4D68F346.1000500@gmail.com>	<AANLkTin3nY6++whgOGTC=HLN_oK0J5chsx5uZ_OG6h8G@mail.gmail.com>	<4D6917C6.2050509@gmail.com> <AANLkTinRyzkt_PtbnM4pNUUd7gwXSMQsTOVS9otG7v6D@mail.gmail.com>
In-Reply-To: <AANLkTinRyzkt_PtbnM4pNUUd7gwXSMQsTOVS9otG7v6D@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2011 04:01 AM, huang ying wrote:
...
>>
>>   Probably we should put question in another fashion, ie in the fasion of
>> overall design -- who should be
>> responsible for handling external nmis, 1) the cpu which apic is configured
>> to observe such nmis or 2) any cpu?
>> If we take 1) then no lock is needed and underlied code will report real cpu
>> number who observed nmi. If
>> we take 2) then lock is needed but we need a big comment in default_do_nmi
>> together with probably cpu number
>> fixed in serr\iochk printk's.
>
> I am OK with both solutions.
>
> Best Regards,
> Huang Ying

ok, lets see what others think on this thread

-- 
     Cyrill
