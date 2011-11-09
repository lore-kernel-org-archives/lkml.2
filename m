Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab1KILGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:06:47 -0500
Received: from service87.mimecast.com ([91.220.42.44]:59660 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab1KILGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:06:45 -0500
Subject: Re: [PATCH RFC] virtio-spec: flexible configuration layout
From: Pawel Moll <pawel.moll@arm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Wang Sheng-Hui <shhuiw@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
In-Reply-To: <1320836144.31056.35.camel@lappy>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
	 <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy>
	 <20111101124223.GA14060@redhat.com> <8739e7uy87.fsf@rustcorp.com.au>
	 <20111102233110.GA20289@redhat.com> <20111108214021.GA4538@redhat.com>
	 <1320832502.31056.22.camel@lappy>  <20111109101814.GC20612@redhat.com>
	 <1320834017.31056.26.camel@lappy>
	 <1320835653.3259.138.camel@hornet.cambridge.arm.com>
	 <1320836144.31056.35.camel@lappy>
Date: Wed, 09 Nov 2011 11:06:33 +0000
Message-ID: <1320836793.3259.151.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 09 Nov 2011 11:06:34.0326 (UTC) FILETIME=[A4909760:01CC9ECF]
X-MC-Unique: 111110911064002801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 10:55 +0000, Sasha Levin wrote:
> On Wed, 2011-11-09 at 10:47 +0000, Pawel Moll wrote:
> > Yep, it's actually already in 3.2-rc1 (drivers/virtio/virtio_mmio.c) and
> > in the spec (see Appendix X). And actually the control registers layout
> > I used was originally based on the PCI "legacy" headers (slightly
> > simplified), but evolved a bit since. My understanding is that the
> > changes Michael is proposing affect the PCI device interface only so
> > they shouldn't affect "my" interface.
> 
> I didn't know it's in already, might be interesting adding support to it
> to x86 userspace tools.

Do you mean the qemu or the (non-qemu) KVM tools I know nothing
about? ;-)

If qemu, Peter got it already running with virtio_mmio on ARM models
(not upstream yet as far as I know), but I presume the code would we
mostly non-ARM specific.

Cheers!

Pawel


