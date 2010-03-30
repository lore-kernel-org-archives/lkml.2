Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0C3IAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:00:51 -0400
Received: from lucidpixels.com ([75.144.35.66]:56090 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab0C3IAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:00:50 -0400
Date: Tue, 30 Mar 2010 04:00:48 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Borislav Petkov <bp@amd64.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: EDAC: Is it possible to calculate which piece of memory is
 bad?
In-Reply-To: <20100330070544.GA19488@aftab>
Message-ID: <alpine.DEB.2.00.1003300400260.13468@p34.internal.lan>
References: <alpine.DEB.2.00.1003290939340.27175@p34.internal.lan> <20100330070544.GA19488@aftab>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Mar 2010, Borislav Petkov wrote:

> From: Justin Piszcz <jpiszcz@lucidpixels.com>
> Date: Mon, Mar 29, 2010 at 09:40:38AM -0400
>
>> Hello,
>>
>> I see the following errors:
>>
>> EDAC MC0: CE page 0x8abba, offset 0xa10, grain 8, syndrome 0x4758, row 0, channel 0, label "": k8_edac
>
> It looks like it is the first DIMM on your mainboard, i.e., whichever
> gets mapped to channel 0 of the DCT.
>
> Sigh, someday we'll have a better mapping, hopefully, ... :|
>
>> EDAC MC0: CE - no information available: k8_edac Error Overflow set
>> EDAC k8 MC0: extended error code: ECC chipkill x4 error
>> EDAC k8 MC0: general bus error: participating processor(local node origin), time-out(no timeout) memory transaction type(generic read), mem or i/o(mem access), cache level(generic)
>>
>> Is it possible to use the page or offset to calculate which DIMM is having a
>> problem?
>
>
> -- 
> Regards/Gruss,
> Boris.
>
> --
> Advanced Micro Devices, Inc.
> Operating Systems Research Center
>

Hi,

Thanks, how did you make that calculation?

Justin.
