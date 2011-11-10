Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241Ab1KJJti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:49:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33692 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1KJJtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:49:33 -0500
MIME-Version: 1.0
In-Reply-To: <4EBB9CA4.3050606@redhat.com>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
 <4EBB4A21.20707@codemonkey.ws> <alpine.LFD.2.02.1111100829560.1791@tux.localdomain>
 <m3pqh0tnoi.fsf@blackfin.pond.sub.org> <CA+1xoqe22z9F3ZyFG_XnV9Y17HtkeSxtf1gbW4+CW1cuNQ=N5g@mail.gmail.com>
 <m3fwhws6ci.fsf@blackfin.pond.sub.org> <CA+1xoqc7f-2azcjuLB_i_C_CCDt+gPqJe=SB5MmOiM0y6uY_cg@mail.gmail.com>
 <4EBB94D9.30906@redhat.com> <CA+1xoqdf2_j4yg=CacMpsDmtz3y30G9_BAyM=Mjsr3rQdAJ+tg@mail.gmail.com>
 <4EBB9809.1080603@redhat.com> <CA+1xoqdNfX03O6cToOW5wgcbZa7bHvqPPTnMUAH5Ltvs8nMrpg@mail.gmail.com>
 <4EBB9CA4.3050606@redhat.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 10 Nov 2011 11:49:10 +0200
Message-ID: <CA+1xoqfg3sJ7ApWWOuhPCDz+GATY2NMx3r_cKiM9TPpAWYRawQ@mail.gmail.com>
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
To: Avi Kivity <avi@redhat.com>
Cc: Markus Armbruster <armbru@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 11:43 AM, Avi Kivity <avi@redhat.com> wrote:
> On 11/10/2011 11:34 AM, Sasha Levin wrote:
>> On Thu, Nov 10, 2011 at 11:23 AM, Avi Kivity <avi@redhat.com> wrote:
>> > On 11/10/2011 11:14 AM, Sasha Levin wrote:
>> >> > Trying and failing.  sVirt will deny access to all files except those
>> >> > explicitly allowed by libvirt.
>> >>
>> >> It still allows the guest to read more than enough files which it
>> >> shouldn't be reading.
>> >>
>> >> Unless you configure sVirt on a per-guest basis...
>> >
>> > sVirt is per-guest.
>>
>> It still would mean that the guest can access any file (actually, even
>> device, no?) the hypervisor can access.
>
> It does, but the hypervisor can only access the guest's images, and a
> few internal files (like the qemu-kvm executable and its libraries).

What about devices? You let the guest read and write to devices as
well (/dev/kvm for example, or network devices).
