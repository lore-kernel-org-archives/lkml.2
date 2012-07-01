Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2GAJt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 05:49:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab2GAJt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 05:49:57 -0400
Message-ID: <4FF01D41.5070600@redhat.com>
Date: Sun, 01 Jul 2012 12:49:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: Tree for June 29 (kvm)
References: <20120629175341.22a9eccd30d9c085bfd92c1d@canb.auug.org.au> <4FEDEE6A.7020608@xenotime.net> <4FF01B59.1010600@redhat.com> <20120701094430.GB4642@redhat.com>
In-Reply-To: <20120701094430.GB4642@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 12:44 PM, Michael S. Tsirkin wrote:
> On Sun, Jul 01, 2012 at 12:41:45PM +0300, Avi Kivity wrote:
>> On 06/29/2012 09:05 PM, Randy Dunlap wrote:
>> > On 06/29/2012 12:53 AM, Stephen Rothwell wrote:
>> > 
>> >> Hi all,
>> >> 
>> >> Changes since 20120628:
>> > 
>> > 
>> > 
>> > on i386:
>> > 
>> > arch/x86/built-in.o: In function `kvm_guest_apic_eoi_write':
>> > kvm.c:(.text+0x3561f): undefined reference to `apic'
>> > 
>> > 
>> > Full randconfig file is attached.
>> 
>> Michael, please disable pveoi if built with no apic.
> 
> Will do.
> How do I tweak config to test this? Any hints?

See the original mail, there's a .config there.  Basically, i386 UP with
IOAPIC disabled.



-- 
error compiling committee.c: too many arguments to function


