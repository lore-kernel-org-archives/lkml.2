Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab1EBFvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 01:51:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41081 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1EBFve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 01:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tz2iYl3HtOfV51hHHhBxazpKijpGIpBG/bC03KWKDnpVhQ5e+x0jUs1sJizDOAaDO9
         hfDX9B491hRTwDeSH4umZ+8EG2357KVDB3BsnrRevE+Sm6e+8Hw+6+/zOxoearA7ZMgW
         +LKgPmYFOYfBAwAASjMqNXoTQH+/gl6kV0a9s=
MIME-Version: 1.0
In-Reply-To: <20110502053928.GB18376@redhat.com>
References: <20110430171459.685415696@openvz.org>
	<4DBC6DC1.30900@redhat.com>
	<20110501164635.GA21833@elte.hu>
	<BANLkTimpk3Ye=HvCohTbKT7Jzedo_V07Yg@mail.gmail.com>
	<20110502053928.GB18376@redhat.com>
Date: Mon, 2 May 2011 09:51:32 +0400
X-Google-Sender-Auth: Dny-IXWk6VaulyIjGtyjyuRf2gg
Message-ID: <BANLkTi=Bw5k1_oytZmXgTrQ-XUJisp3vfQ@mail.gmail.com>
Subject: Re: [patch 0/2] x2apic optimization, round 4
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, i'll do so as only bring my laptop to life, I managed to kill
grub and can't restore it back for a while, will ping you back as soon
as I can.

Sorry for top post.

On Monday, May 2, 2011, Gleb Natapov <gleb@redhat.com> wrote:
> On Sun, May 01, 2011 at 09:11:35PM +0400, Cyrill Gorcunov wrote:
>> On Sun, May 1, 2011 at 8:46 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Avi Kivity <avi@redhat.com> wrote:
>> >
>> >> On 04/30/2011 08:14 PM, Cyrill Gorcunov wrote:
>> >> >   Hi Ingo, here is an updated series of two patches for
>> >> >x2apic cluster mode ipi optimization. Please take a
>> >> >look.
>> >> >
>> >> >   The only concern which was unresolved is a messy bit
>> >> >in default_setup_apic_routing(), so we've added a FIXME
>> >> >there and clean it up as only time permits. Actually I
>> >> >have a plan to merge probe_32/64.c into single file (and
>> >> >even started working on this task) but not yes succeed.
>> >> >
>> >> >   Anyway I think patches should be in a good shape now and
>> >> >probably we could merge them to not lose?
>> >> >
>> >> >   Comments are welcome.
>> >>
>> >> Very nice!  This will also significantly speed up kvm guests using x2apic.
>> >
>> > Ok. It would be nice to know on what systems these patches were tested, i.e. i
>> > suppose x2apic-enabled ones?
>> >
>> > Thanks,
>> >
>> >        Ingo
>> >
>>
>> Suresh has tested them on Westmere-Ex system, I personally don't have
>> such machine.
> Can you test in in KVM with x2apic emulation enabled?
>
> --
>                         Gleb.
>
