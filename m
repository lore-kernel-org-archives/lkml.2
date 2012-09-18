Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab2IRLEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:04:12 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:44555 "EHLO
	Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab2IRLEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:04:11 -0400
Message-ID: <50585526.8050006@tlinx.org>
Date: Tue, 18 Sep 2012 04:04:06 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Gecko/20100228 Lightning/0.9 Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2 physical-cpu (like 2x6core) config and NUMA?
References: <5057654A.803@tlinx.org> <CANE52Khbw0-iA=nAebySc=Fw-6CtY-wuOC9Kw_UE3mbkOAKJmA@mail.gmail.com>
In-Reply-To: <CANE52Khbw0-iA=nAebySc=Fw-6CtY-wuOC9Kw_UE3mbkOAKJmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song wrote:
> Do you have anything printed with:
>
>  # acpidump -a --table SRAT
>   
It prints out a bunch of stuff, but the word SRAT wasn't in the
output.

I don't remember a node interleaving in the BIOS -- There's a ECC mode,
where I only get 4/6 slots for usable memory, or an optimized mode that uses
6/6 mem sort.  Each processer has it's own set of 6-slots for memory
(PowerEdge 610 dual X5660's)...

I wonder if the optimizing mode is node interleaving?   But the only other
result results in taking a 1/3rd memory penalty...Hmm...

I'm wondering about this BIOS .. I had to use pcie_aspm=force to get it
to get some parts to work at all.  Like the on-board I/O DMA engine --
linux didn't even see the hardware without the aspm=force.

Maybe a bios update is needed?  will probe along those lines...

I can always call Dell tech support...still under warantee...;-)

Thanks for the ideas and confirmation....


> Hope that helps.
>   
Yep!


