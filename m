Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0CaWEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:04:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:60741 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839Ab0CaWEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:04:38 -0400
Message-ID: <4BB3C691.5000002@kernel.org>
Date: Wed, 31 Mar 2010 15:02:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       airlied@linux.ie, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>	 <4BB2EB1B.8090303@zytor.com>	 <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>	 <20100331185916.GA12306@elte.hu> <r2h21d7e9971003311414pc38f5bebk1778a01872657395@mail.gmail.com>
In-Reply-To: <r2h21d7e9971003311414pc38f5bebk1778a01872657395@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 02:14 PM, Dave Airlie wrote:
> On Thu, Apr 1, 2010 at 4:59 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * James Morris <jmorris@namei.org> wrote:
>>
>>> On Tue, 30 Mar 2010, H. Peter Anvin wrote:
>>>
>>>> On 03/30/2010 09:49 PM, James Morris wrote:
>>>>>
>>>>> Please make NO_BOOTMEM default to n, at least for amd64, where I've found
>>>>> that it leads to all kinds of strange, undebuggable boot hangs and errors
>>>>> (with relatively current Fedora development userland).
>>>>
>>>> Have you tested it with the latest fixes that are now in Linus' tree (-rc3)?
>>>
>>> Yes, it was happening with -rc3.
>>
>> Could you please send the bootlog that Yinghai asked for, plus also one that
>> you get with NO_BOOTMEM turned off (for comparison)?
>>
>> Also, when did you first hit this bug? This code has been upstream for almost
>> a month, and it was in linux-next before that - so you should have hit this
>> much sooner. A rough timeframe would suffice. I suppose you were booting
>> upstream kernels during the merge window as well?
>>
>> We can flip the default around if there's no fix available based on the
>> bootlogs. (Plus the help text should definitely be improved.)
>>
> 
> Are you testing this btw with initramfs/initrds? I suspect lots of testing
> is being done by people on monolithic kernels, this is just a misc guess,
> considering I couldn't boot from when this landed until rc3 with this option
> on a basic 32-bit install on a dual-core 64-bit CPU, it suggested a
> hole of some sort
> in the test coverage.

so -rc3 is working your setup?

Yinghai
