Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0ESOJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:09:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54264 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab0ESOJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:09:02 -0400
Message-ID: <4BF3F0D3.6070609@zytor.com>
Date: Wed, 19 May 2010 07:08:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eric.dumazet@gmail.com, Ingo Molnar <mingo@elte.hu>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>
Subject: Re: Does anyone care about gcc 3.x support for *x86* anymore?
References: <4BF33CAD.2070602@zytor.com> <871vd8xb8t.fsf@basil.nowhere.org>
In-Reply-To: <871vd8xb8t.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 06:38 AM, Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>>
>> If there isn't a reason to preserve support, I would like to consider
>> discontinue support for using gcc 3 to compile x86 kernels.  If there is
>> a valid use case, it would be good to know what it is.
> 
> I suspect there are still distributions around that use it as a standard
> compiler. Wasn't it used in some major release of Debian?
> 
> -Andi

There are, but that doesn't mean it's relevant for people to compile
bleeding-edge kernels with it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

