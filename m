Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab2EQGUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 02:20:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44756 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab2EQGUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 02:20:32 -0400
MIME-Version: 1.0
In-Reply-To: <1337214652.22052.1.camel@nisroch>
References: <4FB3EF1C.5040804@canonical.com>
	<1337214652.22052.1.camel@nisroch>
Date: Thu, 17 May 2012 16:20:31 +1000
Message-ID: <CACAvsv551Q2Wb=bj6piizN88-+k-wCJS0FgT5j5KiK5N3Se=Gw@mail.gmail.com>
Subject: Re: 3.4-rc7 backlight regression on Dell XPS M1710
From: Ben Skeggs <skeggsb@gmail.com>
To: bskeggs@redhat.com
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:30 AM, Ben Skeggs <bskeggs@redhat.com> wrote:
> Am Mittwoch, den 16.05.2012, 12:17 -0600 schrieb Tim Gardner:
>> commit b99da31ed8521eb78d5d6930f3128f8ecdb75fae causes the backlight in
>> my Dell XPS M1710 to stop working. Symptoms are dim display and won't
>> respond to key brightness events. I bisected and confirmed that
>> reverting this single patch on top of 3.4-rc7 fixes the problem.
> That commit is correct, it may have uncovered a bug elsewhere though.
It's been pointed out I should probably be a bit more verbose about
what I'm after here... Apologies :)

The commit that causes the original regression is
a0b25635515ef5049f93b032a1e37f18b16e0f6f.  Did your backlight work
correctly before this?

Thanks,
Ben.

>
> Cheers,
> Ben.
>
>>
>> 01:00.0 VGA compatible controller [0300]: nVidia Corporation G71
>> [GeForce Go 7900 GS] [10de:0298] (rev a1)
>>       Subsystem: Dell Device [1028:019b]
>>       Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>       Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>       Latency: 0, Cache Line Size: 64 bytes
>>       Interrupt: pin A routed to IRQ 16
>>       Region 0: Memory at ed000000 (32-bit, non-prefetchable) [size=16M]
>>       Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
>>       Region 3: Memory at ee000000 (64-bit, non-prefetchable) [size=16M]
>>       Region 5: I/O ports at ef00 [size=128]
>>       Expansion ROM at efe00000 [disabled] [size=128K]
>>       Capabilities: <access denied>
>>       Kernel driver in use: nouveau
>>       Kernel modules: nouveau, nvidiafb
>>
>> rtg
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
