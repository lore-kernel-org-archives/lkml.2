Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab0EDHmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 03:42:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab0EDHmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 03:42:05 -0400
Message-ID: <4BDFCF9F.3030600@redhat.com>
Date: Tue, 04 May 2010 10:41:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Brian Gerst <brgerst@gmail.com>,
       Dexuan Cui <dexuan.cui@intel.com>, Sheng Yang <sheng@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: eliminate TS_XSAVE
References: <1272812038-32484-1-git-send-email-avi@redhat.com>	 <1272812038-32484-2-git-send-email-avi@redhat.com> <u2p73c1f2161005021038gce35c1bbpca6ec119d24e646e@mail.gmail.com> <4BDDBA18.3080909@redhat.com> <4BDF4407.8000503@zytor.com>
In-Reply-To: <4BDF4407.8000503@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2010 12:45 AM, H. Peter Anvin wrote:
>
>> I was trying to avoid a performance regression relative to the current
>> code, as it appears that some care was taken to avoid the memory reference.
>>
>> I agree that it's probably negligible compared to the save/restore
>> code.  If the x86 maintainers agree as well, I'll replace it with
>> cpu_has_xsave.
>>
>>      
> I asked Suresh to comment on this, since he wrote the original code.  He
> did confirm that the intent was to avoid a global memory reference.
>
>    

Ok, so you're happy with the patch as is?

-- 
error compiling committee.c: too many arguments to function

