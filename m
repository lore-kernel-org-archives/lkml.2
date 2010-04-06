Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0DFTxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:53:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35710 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab0DFTxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:53:49 -0400
Message-ID: <4BBB8F07.60401@zytor.com>
Date: Tue, 06 Apr 2010 12:44:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frank Hu <frank.hu.2001@gmail.com>
CC: Joel Fernandes <agnel.joel@gmail.com>,
       hayfeng Lee <teklife.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org, kernelnewbies@nl.linux.org
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>	 <g2s9ff7a3bc1004060802va38aa361s6abd07e8c992dd56@mail.gmail.com>	 <4BBB7AC9.5060008@zytor.com> <o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com>
In-Reply-To: <o2m8f84f9951004061220x16f3aa8by9cf19ec28ea492d7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 12:20 PM, Frank Hu wrote:
>>
>> The ELF ABI specifies that user space has 3 GB available to it.  That
>> leaves 1 GB for the kernel.  The kernel, by default, uses 128 MB for I/O
>> mapping, vmalloc, and kmap support, which leaves 896 MB for LOWMEM.
>>
>> All of these boundaries are configurable; with PAE enabled the user
>> space boundary has to be on a 1 GB boundary.
>>
> 
> the VM split is also configurable when building the kernel (for 32-bit
> processors).

I did say "all these boundaries are configurable".  Rather explicitly.

	-hpa
