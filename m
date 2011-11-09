Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab1KILjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:39:47 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65266 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab1KILjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:39:45 -0500
MIME-Version: 1.0
In-Reply-To: <1320836793.3259.151.camel@hornet.cambridge.arm.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
	<20111101114542.GA13434@redhat.com>
	<1320150813.3847.24.camel@lappy>
	<20111101124223.GA14060@redhat.com>
	<8739e7uy87.fsf@rustcorp.com.au>
	<20111102233110.GA20289@redhat.com>
	<20111108214021.GA4538@redhat.com>
	<1320832502.31056.22.camel@lappy>
	<20111109101814.GC20612@redhat.com>
	<1320834017.31056.26.camel@lappy>
	<1320835653.3259.138.camel@hornet.cambridge.arm.com>
	<1320836144.31056.35.camel@lappy>
	<1320836793.3259.151.camel@hornet.cambridge.arm.com>
Date: Wed, 9 Nov 2011 11:39:44 +0000
Message-ID: <CAFEAcA8Ci1_t=qruaAwU_NeR=_WD=7NUsDwqL_qMTyDb4HVBxA@mail.gmail.com>
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
From: Peter Maydell <peter.maydell@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Wang Sheng-Hui <shhuiw@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 November 2011 11:06, Pawel Moll <pawel.moll@arm.com> wrote:
> On Wed, 2011-11-09 at 10:55 +0000, Sasha Levin wrote:
>> On Wed, 2011-11-09 at 10:47 +0000, Pawel Moll wrote:
>> > Yep, it's actually already in 3.2-rc1 (drivers/virtio/virtio_mmio.c) and
>> > in the spec (see Appendix X). And actually the control registers layout
>> > I used was originally based on the PCI "legacy" headers (slightly
>> > simplified), but evolved a bit since. My understanding is that the
>> > changes Michael is proposing affect the PCI device interface only so
>> > they shouldn't affect "my" interface.
>>
>> I didn't know it's in already, might be interesting adding support to it
>> to x86 userspace tools.
>
> Do you mean the qemu or the (non-qemu) KVM tools I know nothing
> about? ;-)
>
> If qemu, Peter got it already running with virtio_mmio on ARM models
> (not upstream yet as far as I know), but I presume the code would we
> mostly non-ARM specific.

The QEMU code is completely non-ARM-specific (apart from the line
in the relevant ARM board models where we instantiate the devices).
I haven't submitted it upstream yet though because really the
virtio transport layer in QEMU needs to be refactored as a qdev
bus first.

-- PMM
