Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1BWEfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:35:51 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52172 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1BWEfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:35:50 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1102222149370.22028@xanadu.home>
References: <20110223021524.18318.71902.stgit@localhost6.localdomain6>
 <20110223022239.18318.87333.stgit@localhost6.localdomain6> <alpine.LFD.2.00.1102222149370.22028@xanadu.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 22 Feb 2011 21:35:30 -0700
X-Google-Sender-Auth: o95o5waI_ICVD7Uyk85TwMbGkEU
Message-ID: <AANLkTikoZDR2pCLT8RcS8S03QU1J8cTcDjZzc6ct+QUi@mail.gmail.com>
Subject: Re: [PATCH v4 7/7] dt: add documentation of ARM dt boot interface
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 7:55 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Tue, 22 Feb 2011, Grant Likely wrote:
>
>> +The boot loader must load a device tree image (dtb) into system ram
>> +at a 64bit aligned address and initialize it with the boot data.
> [...]
>> +                r2 : physical pointer to the device-tree block
>> +                (defined in chapter II) in RAM.  Device tree can be located
>> +                anywhere in system RAM, but it should be aligned on a 32 bit
>> +                boundary.
>
> So... which one is true?

Oops, I thought I fixed that.  It should be 64 bit boundary (actually,
32 bit is probably just fine, but there are some header fields which
are u64 physical address values so it probably makes sense to keep it
aligned for 64 bits).

g.

>
>
> Nicolas
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
