Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0KWS3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 13:29:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60778 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab0KWS3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 13:29:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=LnFbmHvR1ozrjVxbthZIC+YGozjrOajKCh4R5Gb3DOdSU+12rekeghZsEgPUm86Gdf
         zTSj1coxOE9jT5TrUM2F3HfgdgUl1D6kEPkRoOISPM/QoyzzoxL9bdGaJvP4X9flyYSB
         mJILY4KjlaOk6FVHwtVjEcn0EZFnShmON7TiU=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1290536827.2072.417.camel@laptop>
References: <AANLkTikzSY09i=C+A2Y=_gVa-44r_bN76P-U2-NZMnpz@mail.gmail.com>
	<20101123165657.GF18100@redhat.com>
	<AANLkTimsz2XWQq7bJ4uhWXhoPuQw-fSJbCJ6D6Xo69XM@mail.gmail.com>
	<1290536827.2072.417.camel@laptop>
Date: Tue, 23 Nov 2010 19:29:20 +0100
Message-ID: <AANLkTikOub+x1oo8Cv7hBHgLPF9vjPfzmNwXzEvPPjRK@mail.gmail.com>
Subject: Re: [PATCH] x86, perf, nmi: Disable perf if counters are not accessable
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 7:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-11-23 at 19:21 +0100, Sedat Dilek wrote:
>> Due to BIOS l(ocal)apic is not possible:
>>
>> # dmesg | grep -i apic
>> [    0.000000] Using APIC driver default
>> [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
>> [    0.000000] APIC: disable apic facility
>> [    0.000000] APIC: switched to apic NOOP
>> [    0.008891] no APIC, boot with the "lapic" boot parameter to force-enable it.
>> [    0.036141] Local APIC not detected. Using dummy APIC emulation.
>
> Have you tried booting with "lapic" as the second last msg suggests you
> do?
>

Yes, I did try before there was [1], booting with "lapic" had no effect.

- Sedat -

[1] bugfix/x86/Skip-looking-for-ioapic-overrides-when-ioapics-are-not-present.patch
