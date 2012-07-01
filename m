Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2GAQYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 12:24:45 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:54681 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751941Ab2GAQYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 12:24:43 -0400
Message-ID: <4FF079A9.6090405@xenotime.net>
Date: Sun, 01 Jul 2012 09:24:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, x86@kernel.org
Subject: Re: linux-next: Tree for June 29 (kvm)
References: <20120629175341.22a9eccd30d9c085bfd92c1d@canb.auug.org.au> <4FEDEE6A.7020608@xenotime.net> <4FF01B59.1010600@redhat.com> <20120701094430.GB4642@redhat.com> <4FF01D41.5070600@redhat.com> <20120701105643.GA4782@redhat.com>
In-Reply-To: <20120701105643.GA4782@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 03:56 AM, Michael S. Tsirkin wrote:

> On Sun, Jul 01, 2012 at 12:49:53PM +0300, Avi Kivity wrote:
>> On 07/01/2012 12:44 PM, Michael S. Tsirkin wrote:
>>> On Sun, Jul 01, 2012 at 12:41:45PM +0300, Avi Kivity wrote:
>>>> On 06/29/2012 09:05 PM, Randy Dunlap wrote:
>>>>> On 06/29/2012 12:53 AM, Stephen Rothwell wrote:
>>>>>
>>>>>> Hi all,
>>>>>>
>>>>>> Changes since 20120628:
>>>>>
>>>>>
>>>>>
>>>>> on i386:
>>>>>
>>>>> arch/x86/built-in.o: In function `kvm_guest_apic_eoi_write':
>>>>> kvm.c:(.text+0x3561f): undefined reference to `apic'
>>>>>
>>>>>
>>>>> Full randconfig file is attached.
>>>>
>>>> Michael, please disable pveoi if built with no apic.
>>>
>>> Will do.
>>> How do I tweak config to test this? Any hints?
>>
>> See the original mail, there's a .config there.
> 
> This https://lkml.org/lkml/2012/6/29/40 ?
> I don't see a .config there.

It's in   https://lkml.org/lkml/2012/6/29/350


>> Basically, i386 UP with
>> IOAPIC disabled.


-- 
~Randy
