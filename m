Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0DFUBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:01:52 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:62376 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0DFUBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oMQWVV+PdUVYMuhBV46cA8nJ+Q3yNmIQ2vfVpKRotZjzCYIpxEaQ1dIoG2gkz+KX5g
         4lzNmh4KsGRc1hwniWd9+VYpN6aCqdUO2opMuq5F1rb4OHM5j/al1wFi8MaEr/2EF7X+
         xyyeKM5FsXvidQEgpyNsD9ReEWoxKVEzBUFi8=
MIME-Version: 1.0
In-Reply-To: <4BBB8F07.60401@zytor.com>
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>
	 <g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>
	 <4BBB7AC9.5060008@zytor.com>
	 <o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com>
	 <4BBB8F07.60401@zytor.com>
Date: Wed, 7 Apr 2010 01:31:46 +0530
Message-ID: <w2p9ff7a3bc1004061301v6cc76e1g1e573468b1b8807d@mail.gmail.com>
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
From: Joel Fernandes <agnel.joel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Frank Hu <frank.hu.2001@gmail.com>, hayfeng Lee <teklife.kernel@gmail.com>,
       linux-kernel@vger.kernel.org, linux-kernel@zh-kernel.org,
       kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Apr 7, 2010 at 1:14 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/06/2010 12:20 PM, Frank Hu wrote:
>>>
>>> The ELF ABI specifies that user space has 3 GB available to it.  That
>>> leaves 1 GB for the kernel.  The kernel, by default, uses 128 MB for I/O
>>> mapping, vmalloc, and kmap support, which leaves 896 MB for LOWMEM.
>>>
>>> All of these boundaries are configurable; with PAE enabled the user
>>> space boundary has to be on a 1 GB boundary.
>>>
>>
>> the VM split is also configurable when building the kernel (for 32-bit
>> processors).
>
> I did say "all these boundaries are configurable".  Rather explicitly.
>

I thought the 896 MB was a hardware limitation on 32 bit architectures
and something that cannot be configured? Or am I missing something
here? Also the vm-splits refer to "virtual memory" . While ZONE_* and
the 896MB we were discussing refers to "physical memory". How then is
discussing about vm splits pertinent here?

Thanks,
-Joel
