Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1DWKrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 06:47:35 -0400
Received: from snt0-omc2-s2.snt0.hotmail.com ([65.55.90.77]:46924 "EHLO
	snt0-omc2-s2.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036Ab1DWKrd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 06:47:33 -0400
Message-ID: <SNT125-W501A69BD9948F037646EDFC3940@phx.gbl>
X-Originating-IP: [50.47.160.44]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>
CC: <chris@csamuel.org>, <alan@lxorguk.ukuu.org.uk>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: FW: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on
 quad Pentium Pro system
Date: Sat, 23 Apr 2011 03:47:32 -0700
Importance: Normal
In-Reply-To: <201104231855.47680.chris@csamuel.org>
References: <201104222333.25546.chris@csamuel.org>
 <201104231522.06057.chris@csamuel.org>
 <SNT125-W25B0C502FF72465BC6B55BC3940@phx.gbl>,<201104231855.47680.chris@csamuel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Apr 2011 10:47:32.0510 (UTC) FILETIME=[D95F4BE0:01CC01A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, I walked Chris on how to use DOS DEBUG via private email, and below is the results after the INT 15, using the instruction sequence I posted on the mailing list.Notice HIMEM was not loaded. 

----------------------------------------
> From: chris@csamuel.org
> To: yuhongbao_386@hotmail.com
> Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
> Date: Sat, 23 Apr 2011 18:55:44 +1000
>
> On Sat, 23 Apr 2011 06:28:26 PM Yuhong Bao wrote:
>
>> Actually, execute with G instead, and do it without HIMEM.SYS
>> loaded.
>
> I couldn't see any HIMEM.SYS on the FreeDOS floppy (including
> looking for hidden files) so I'm presuming it's not there. There
> was a HIMEM.EXE so I've renamed it to NOHIMEM.OFF in the hope
> that it won't get executed, even in the safe mode I was using.
>
> Using G instead of A I now get:
>
> -G
> Unexpected breakpoint interrupt.
> AX=3C00 BX=0F00 CX=0000 DX=0000 SP=FFFE BP=0000 SI=0000 DI=0000
> DS=2890 ES=2890 SS=2890 CS=2890 IP=0106 NV UP DI PL NZ NA PE NC
> 2890:0106 0000 ADD [BX+SI], AL D:0F00=00
> -
>
> cheers,
> Chris
> --
> Chris Samuel : http://www.csamuel.org/ : Melbourne, VIC
>
> This email may come with a PGP signature as a file. Do not panic.
> For more info see: http://en.wikipedia.org/wiki/OpenPGP
 		 	   		  