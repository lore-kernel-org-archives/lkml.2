Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0ESWpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 18:45:11 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:38575 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0ESWpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 18:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=m5yhWrQZQMHJbHzENcCb3T5SGuu64BE4eaPsr7Uvm580oSMXVsBocgDAwRRb1GPARH
         yj3vtYdQx4BgjWbl+ZZQrX02tOLLaFCo/Fogc4sgQeI2GGslKG2jsXzTPcK9OJOzn3bm
         ox4mI6sxVqNC3qFGbgsioIEF2Z8eQJFG4gqBw=
Message-ID: <4BF469F6.3050300@gmail.com>
Date: Wed, 19 May 2010 15:45:10 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eric.dumazet@gmail.com, Ingo Molnar <mingo@elte.hu>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>
Subject: Re: Does anyone care about gcc 3.x support for *x86* anymore?
References: <4BF33CAD.2070602@zytor.com> <871vd8xb8t.fsf@basil.nowhere.org> <4BF3F0D3.6070609@zytor.com>
In-Reply-To: <4BF3F0D3.6070609@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 07:08 AM, H. Peter Anvin wrote:
> On 05/19/2010 06:38 AM, Andi Kleen wrote:
>> "H. Peter Anvin"<hpa@zytor.com>  writes:
>>>
>>> If there isn't a reason to preserve support, I would like to consider
>>> discontinue support for using gcc 3 to compile x86 kernels.  If there is
>>> a valid use case, it would be good to know what it is.
>>
>> I suspect there are still distributions around that use it as a standard
>> compiler. Wasn't it used in some major release of Debian?
>>
>> -Andi
>
> There are, but that doesn't mean it's relevant for people to compile
> bleeding-edge kernels with it.
>
> 	-hpa
>

no need for it here(using 4.6.0)..
Any distro still using this version
should upgrade(but who am I to say anything)

cheers.

Justin P. Mattock
