Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab2BXTh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:37:59 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35131 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab2BXTh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:37:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of lacombar@gmail.com designates 10.180.102.132 as permitted sender) smtp.mail=lacombar@gmail.com; dkim=pass header.i=lacombar@gmail.com
MIME-Version: 1.0
In-Reply-To: <F45DDB02-E434-4F32-BBA0-1BB2F2EFD3D6@kasr.elf.stuba.sk>
References: <5240114.8TkZqEVLeL@fodrek.kar.elf.stuba.sk>
	<CAJd=RBCdxEv=OATcNw1yugCF7g=Ba8fFLQE0D6QTAkO8BRoqrQ@mail.gmail.com>
	<F45DDB02-E434-4F32-BBA0-1BB2F2EFD3D6@kasr.elf.stuba.sk>
Date: Fri, 24 Feb 2012 14:37:56 -0500
Message-ID: <CACqU3MXL1TTYF-1VQiU9sE-xPcjcORyaPPHoZUMR7vVgq5MhOQ@mail.gmail.com>
Subject: Re: Resening: KGDB over Ethternet howto patch
From: Arnaud Lacombe <lacombar@gmail.com>
To: Peter Fodrek <fodrek@kasr.elf.stuba.sk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 24, 2012 at 2:14 PM, Peter Fodrek <fodrek@kasr.elf.stuba.sk> wrote:
> Dear Linux hackers,
>
> Thak you for all your answers. All will be helpfull for us.
>
> On Friday 24 February 2012 15:16:10 Pekka Enberg wrote:
>> There's some traces of "kgdboe" in mainline code but I don't think
>> that feature was ever merged.
>
> Therefor I am not to find out kdboe anymore.
>
Last time I used it, it was with 2.6.32. Patches are available there:

https://github.com/lacombar/linux-2.6/tree/v2.6.32-kgdboe

Port to 3.2 is trivial. I could get the connection, break into the
gdb, but failed to set breakpoints. I did not investigate further at
the time.

 - Arnaud

> On Friday 24 February 2012 21:47:47 Hillf Danton wrote:
>> Perhaps you could google KGTP, and try to be another user of it.
>
> This is something like what  we need as I see via first look
>
> On Friday 24 February 2012 13:55:17 Alan Cox wrote:
>> netconsole is probably what you want as a starting point. It lets you use
>> a ethernet device as a one way console right from early boot
>
>
> This is something that we need for another work.
>
> Thank you one again for your help
>
> Kind regards
>
> Peter Fodrek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
