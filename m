Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab1DCJGW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 05:06:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62152 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab1DCJGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 05:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wwLqeU8ETK4FrTjB6djBevRdKu9hGgZSFAfmcerxH5r+DVXTcTl4VkLjVnKzxApO1y
         mFYuA9nSLq+0QVb0dVTDdoCAiGumtofy4XdZ+sdvq3rsTWMsxxf8pcKzNFMdSysFStkd
         bPG8JYXHrlGnLwrIKIeqzc4QLWNAzv9J74MPU=
Message-ID: <4D983885.1090704@gmail.com>
Date: Sun, 03 Apr 2011 13:06:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar>	<4D978930.1000909@codemonkey.ws>	<20110403062117.GA27121@elte.hu>	<4D982EB8.7080001@redhat.com> <BANLkTikkyktU3KL8h71PYLF_ds0C07QKcg@mail.gmail.com>
In-Reply-To: <BANLkTikkyktU3KL8h71PYLF_ds0C07QKcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2011 12:53 PM, Pekka Enberg wrote:
> Hi,
> 
> On Sun, Apr 3, 2011 at 11:24 AM, Avi Kivity <avi@redhat.com> wrote:
>> On 04/03/2011 09:21 AM, Ingo Molnar wrote:
>>>
>>> * Anthony Liguori<anthony@codemonkey.ws>  wrote:
>>>
>>>>  On 03/31/2011 12:30 PM, Pekka Enberg wrote:
>>>>  >  Hi all,
>>>>  >
>>>>  >  We’re proud to announce the native Linux KVM tool!
>>>>
>>>>  Neat!
>>>>
>>>>  As something of a lesson of history, I'd suggest picking a more unique
>>>> name
>>>>  while it's still a prototype :-)
>>>
>>> I disagree, i find it pretty handy and intuitive to run 'kvm ./disk.img'
>>> to
>>> boot KVM and this particular tool name has not been taken yet either.
>>
>> Some distributions install qemu-kvm as /usr/bin/kvm.
>>
>>> perf uses a similar concept: the kernel subsystem is generally called
>>> 'perf',
>>> and the (Linux specific) user-space tool is called 'perf' as well. It
>>> makes
>>> quite a bit of sense.
>>
>> Well, this is bound to cause confusion as the tool is yet quite immature.
> 
> Yes, that's really unfortunate. I don't care too much what we call the
> tool but I definitely agree with Ingo that 'kvm' is more discoverable
> to users. Any suggestions?
> 
>                         Pekka

Well, I personally do not care much either. If there a fear we might interfere
with some distribution probably we could re-name it "nkvm" (ie from Native KVM).
I've googled it and found there is no such name used yet. Hm?

-- 
    Cyrill
