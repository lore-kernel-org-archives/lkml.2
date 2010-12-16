Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab0LPS4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:56:05 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:48563 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab0LPS4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:56:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RcfNPIlWUfUzW5BeYJPcIFO1VYCUpohJb+xfDQ8rblBo59XC1SS9YZvvEhpIssDua0
         vO6mn3kAGgn6idrXl+2a6OgEE8g8k+zVgXRkaGTE0lb/aKSqCIqw4VJoNNfNWoR4KUv0
         VKGF9v+PDXRUyq0kLbrIEEUYtFWUu6wmonIHE=
Message-ID: <4D0A60BB.4020400@gmail.com>
Date: Thu, 16 Dec 2010 19:55:55 +0100
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
 lock semantics
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home> <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com> <4D08EF4E.8070403@kernel.org> <4D0A3AF2.50508@gmail.com> <4D0A5823.7090200@zytor.com>
In-Reply-To: <4D0A5823.7090200@zytor.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/16/2010 07:19 PM, H. Peter Anvin wrote:
> On 12/16/2010 08:14 AM, Tejun Heo wrote:
>>
>> Are you okay with the patches currently in percpu#for-next?  If so,
>> I'll regenerate patches with your acked-by and pop the two previously
>> mentioned commits and proceed with the rest of the series.
> 
> Still looking through them (sorry.)  I note that we probably do need to
> get Christoph's followup patches into -tip, so we need to get it all
> into tip; as such, even if it goes through your tree I'll need to pull
> it into a tip branch.

Yeah, no problem.  Pekka also wants to pull the essential part into
the memory allocator part, so I think it would be best to keep at
least the proper percpu part and x86 specific ops in percpu tree tho.

Thanks.

-- 
tejun
