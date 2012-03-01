Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab2CACN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:13:28 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:33455 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756175Ab2CACN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:13:26 -0500
Message-ID: <4F4EDB4A.4090006@xenotime.net>
Date: Wed, 29 Feb 2012 18:13:30 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>
Subject: Re: linux-next: Tree for Feb 29 (spear_thermal.c)
References: <20120229175205.d165fa5266f400bc080253a0@canb.auug.org.au>	<4F4EAD36.4070706@xenotime.net> <CAP=VYLoDfhM1gh5Ex-kwOECupk5gwHaj1Nx07ByO1u5ujGXYmA@mail.gmail.com>
In-Reply-To: <CAP=VYLoDfhM1gh5Ex-kwOECupk5gwHaj1Nx07ByO1u5ujGXYmA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 05:35 PM, Paul Gortmaker wrote:

> On Wed, Feb 29, 2012 at 5:56 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On 02/28/2012 10:52 PM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20120228:
>>>
>>> My fixes tree contains:
>>>       x86, efi: Fix unaligned access and endian issues--
>>
>>
>> on x86_64:
>>
>> drivers/built-in.o: In function `spear_thermal_exit':
>> spear_thermal.c:(.text+0x49c042): undefined reference to `clk_disable'
>> spear_thermal.c:(.text+0x49c04b): undefined reference to `clk_put'
>> drivers/built-in.o: In function `spear_thermal_probe':
>> spear_thermal.c:(.text+0x49c0e6): undefined reference to `clk_get'
>> spear_thermal.c:(.text+0x49c0fe): undefined reference to `clk_enable'
>> spear_thermal.c:(.text+0x49c196): undefined reference to `clk_put'
>> spear_thermal.c:(.text+0x49c1cc): undefined reference to `clk_disable'
> 
> Hi Randy,
> 
> I think this should go away once the spear_thermal is limited to
> being built just for that particular ARM platform.
> 
> http://www.spinics.net/lists/linux-next/msg18959.html

Yep, thanks.



> Paul.
> --
> 
>>
>>
>> Full randconfig file is attached.
>>
>> ---
>> ~Randy



-- 
~Randy
