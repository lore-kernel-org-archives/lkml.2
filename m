Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab2EQAZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:25:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760765Ab2EQAZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:25:11 -0400
Message-ID: <1337214652.22052.1.camel@nisroch>
Subject: Re: 3.4-rc7 backlight regression on Dell XPS M1710
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Tim Gardner <tim.gardner@canonical.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Date: Thu, 17 May 2012 10:30:52 +1000
In-Reply-To: <4FB3EF1C.5040804@canonical.com>
References: <4FB3EF1C.5040804@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 16.05.2012, 12:17 -0600 schrieb Tim Gardner:
> commit b99da31ed8521eb78d5d6930f3128f8ecdb75fae causes the backlight in
> my Dell XPS M1710 to stop working. Symptoms are dim display and won't
> respond to key brightness events. I bisected and confirmed that
> reverting this single patch on top of 3.4-rc7 fixes the problem.
That commit is correct, it may have uncovered a bug elsewhere though.

Cheers,
Ben.

> 
> 01:00.0 VGA compatible controller [0300]: nVidia Corporation G71
> [GeForce Go 7900 GS] [10de:0298] (rev a1)
> 	Subsystem: Dell Device [1028:019b]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: Memory at ed000000 (32-bit, non-prefetchable) [size=16M]
> 	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
> 	Region 3: Memory at ee000000 (64-bit, non-prefetchable) [size=16M]
> 	Region 5: I/O ports at ef00 [size=128]
> 	Expansion ROM at efe00000 [disabled] [size=128K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: nouveau
> 	Kernel modules: nouveau, nvidiafb
> 
> rtg


